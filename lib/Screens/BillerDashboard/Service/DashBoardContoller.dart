import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:toasttab/Screens/AuthenticationScreen/AuthenticationScreen.dart';
import 'package:toasttab/Screens/BillerDashboard/Models/Request/BatchItemRequest.dart';
import 'package:toasttab/Screens/BillerDashboard/Models/Response/CustomerModel.dart';
import 'package:toasttab/Screens/BillerDashboard/Models/Response/MenuModel.dart';
import 'package:toasttab/Screens/BillerDashboard/Models/Response/OnlineSessionModel.dart';
import 'package:toasttab/Screens/BillerDashboard/Models/Response/SessionModel.dart';
import 'package:toasttab/Screens/BillerDashboard/Models/Response/TableModel.dart';
import 'package:toasttab/Screens/BillerDashboard/Models/Response/UserModel.dart';
import 'package:toasttab/Screens/BillerDashboard/Service/BillerController.dart';
import 'package:toasttab/main.dart';

class DashboardController extends GetxController {
  bool isLoading = false;
  List<TableData> tables = [];
  List<MenuModel> menus = [];
  List<Category> categories = [];
  List<SessionModel> sessions = [];
  Category? selectedCategory;
  UserModel? userModel;
  BillerController biller = Get.put(BillerController());
  bool newSelected = true;
  bool onlineSelected = false;
  bool otherSelected = false;

  List<OnlineSession> onlineSessions = [];

  bool isLoadingOnlineOrders = false;
  String selectedOnlinePlatform = "";
  bool showOnlineOrders = false;

  bool get isOnlineOrderSelected =>
      selectedOnlinePlatform.isNotEmpty && onlineSessions.isNotEmpty;
      

  List<OnlineSession> walkInSessions = [];

bool isLoadingWalkIns = false;
bool showWalkInCustomers = false;

bool get isWalkInSelected => walkInSessions.isNotEmpty;

  void showToast(String message, {bool isError = false}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: isError ? Colors.red : Colors.green,
      textColor: Colors.white,
    );
  }

  void toggleOnlineOrders() {
    showOnlineOrders = !showOnlineOrders;
    update();
  }
  
  
  Future<void> selectPlatform(String platform) async {
    selectedOnlinePlatform = platform;
    biller.selectedTable = null;
    biller.isCustomerOrder = false;

    await fetchOnlineOrders(platform);

    update();
  }

  int selectedOnlineOrderIndex = 0;
  OnlineSession? get selectedOnlineOrder {
    if (onlineSessions.isEmpty) return null;

    if (selectedOnlineOrderIndex >= onlineSessions.length) {
      selectedOnlineOrderIndex = 0;
    }

    return onlineSessions[selectedOnlineOrderIndex];
  }

  void nextOnlineOrder() {
    if (onlineSessions.isEmpty) return;

    selectedOnlineOrderIndex =
        (selectedOnlineOrderIndex + 1) % onlineSessions.length;

    loadSelectedOnlineOrder();
  }

  void previousOnlineOrder() {
    if (onlineSessions.isEmpty) return;

    selectedOnlineOrderIndex =
        (selectedOnlineOrderIndex - 1 + onlineSessions.length) %
        onlineSessions.length;

    loadSelectedOnlineOrder();
  }

  Future<void> loadSelectedOnlineOrder() async {
    try {
      final order = selectedOnlineOrder;
      if (order == null) {
        log("ORDER IS NULL");
        return;
      }

      biller.selectedSession = SessionModel(
        id: order.id,
        customerName: order.customerName,
        sessionNumber: order.sessionNumber,
      );

      biller.selectedSessionId = order.id;
      await biller.fetchSessionDetail(order.id!);

      update();
    } catch (e, stack) {

    }
  }

  Future<void> fetchOnlineOrders(String channel) async {
    try {
      isLoadingOnlineOrders = true;

      onlineSessions.clear();

      biller.billSummary = null;
      biller.selectedSession = null;
      biller.selectedSessionId = null;

      biller.subTotalAmount = "0";
      biller.taxAmount = "0";
      biller.totalAmount = "0";

      update();

      final url =
          "$baseUrl/orders/restaurants/$restaurantId/sessions?status=OPEN&channel=$channel";
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $authToken",
        },
      );
      final decoded = jsonDecode(response.body);

      log("DECODED RESPONSE => $decoded");

      if (response.statusCode == 200 && decoded["success"] == true) {
        final model = OnlineSessionResponse.fromJson(decoded);
        onlineSessions = model.data;
        if (onlineSessions.isNotEmpty) {
          selectedOnlineOrderIndex = 0;

          await loadSelectedOnlineOrder();
        }
      } else {
        showToast(decoded["message"] ?? "Failed to load orders", isError: true);
      }
    } catch (e, stack) {
      showToast("Unable to fetch online orders", isError: true);
    } finally {
      isLoadingOnlineOrders = false;

      log("FINAL ONLINE SESSION COUNT => ${onlineSessions.length}");

      update();
    }
  }

  getUserProfile() async {
    final response = await http.get(
      Uri.parse("$baseUrl/users/profile"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $authToken",
      },
    );
    final decoded = jsonDecode(response.body);

    if (response.statusCode == 200) {
      userModel = UserModel.fromJson(decoded["data"]);
    } else {
      Get.deleteAll(force: true);
      Get.to(() => AuthenticationScreen());
    }

    update();
  }

  Future<void> fetchTables() async {
    final response = await http.get(
      Uri.parse("$baseUrl/restaurants/$restaurantId/tables"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $authToken",
      },
    );
    final decoded = jsonDecode(response.body);

    if (response.statusCode == 200 && decoded["success"] == true) {
      final tableResponse = TableModel.fromJson(decoded);

      tables = tableResponse.data;
    }

    isLoading = false;
    update();
  }

  Future<void> fetchMenus() async {
    menus = [];
    update();
    final response = await http.get(
      Uri.parse(baseUrl + "/restaurants/${restaurantId}/menu?fetchAll=true"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $authToken",
      },
    );
    if (response.statusCode == 200) {
      var responseBody = json.decode(response.body);
      for (var menu in responseBody["data"]["data"]) {
        menus.add(MenuModel.fromJson(menu));
      }
    }
    fetchCategory();
    update();
  }

  void fetchCategory() async {
    categories.add(Category(id: "0", name: "All"));
    selectedCategory = categories.first;
    for (var menu in menus) {
      if (categories.where((it) => it.id == menu.categoryId).isEmpty) {
        categories.add(menu.category!);
      }
    }
    update();
  }

  void fetchAllPendingSession() async {
    sessions = [];
    update();
    final response = await http.get(
      Uri.parse(
        baseUrl + "/orders/restaurants/${restaurantId}/sessions?status=OPEN",
      ),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $authToken",
      },
    );

    if (response.statusCode == 200) {
      for (var data in json.decode(response.body)["data"]) {
        final session = SessionModel.fromJson(data);
        if (sessions.where((it) => it.id == session.id).isEmpty) {
          sessions.add(session);
        }
        update();
      }
      print(sessions);
    }
  }

  MenuModel batchItemtoMenuItem(BatchItemModel batchItem) {
    return menus.where((it) => it.id == batchItem.menuItemId).first;
  }

  MenuModel menuFromId(String menuID) {
    return menus.where((it) => it.id == menuID).first;
  }

  Future<List<CustomerModel>> fetchCustomer(SearchString) async {
    final response = await http.get(
      Uri.parse(
        baseUrl + "/restaurants/${restaurantId}/customers?search=$SearchString",
      ),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $authToken",
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      List<CustomerModel> customers = [];
      for (var cs in json.decode(response.body)["data"]["data"]) {
        customers.add(CustomerModel.fromJson(cs));
      }

      return customers;
    }

    return [];
  }

  changeMenuStatus(
    MenuModel item, {
    bool stockStatus = false,
    int count = 0,
  }) async {
    final response = await http.post(
      Uri.parse(baseUrl + "/restaurants/${restaurantId}/menu/${item.id}/stock"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $authToken",
      },
      body: json.encode({
        "action": (stockStatus == false) ? "MARK_OUT_OF_STOCK" : "RESTOCK",
        if (item.itemType == "STOCKABLE")
          "quantity": (stockStatus == false) ? 0 : count,
      }),
    );

    if (response.statusCode == 200) {
      update();
    }
  }
   int selectedWalkInIndex = 0;

OnlineSession? get selectedWalkInSession {
  if (walkInSessions.isEmpty) return null;

  if (selectedWalkInIndex >= walkInSessions.length) {
    selectedWalkInIndex = 0;
  }

  return walkInSessions[selectedWalkInIndex];
}

void nextWalkInCustomer() {
  if (walkInSessions.isEmpty) return;

  selectedWalkInIndex =
      (selectedWalkInIndex + 1) % walkInSessions.length;

  loadSelectedWalkInCustomer();
}

void previousWalkInCustomer() {
  if (walkInSessions.isEmpty) return;

  selectedWalkInIndex =
      (selectedWalkInIndex - 1 + walkInSessions.length) %
      walkInSessions.length;

  loadSelectedWalkInCustomer();
}

Future<void> loadSelectedWalkInCustomer() async {
  try {
    final session = selectedWalkInSession;

    if (session == null) return;

    biller.selectedTable = null;
    biller.isCustomerOrder = true;

    biller.selectedSession = SessionModel(
      id: session.id,
      customerName: session.customerName,
      sessionNumber: session.sessionNumber,
    );

    biller.selectedSessionId = session.id;

    await biller.fetchSessionDetail(session.id!);

    update();
  } catch (e) {
    log(e.toString());
  }
}
Future<void> fetchWalkInCustomers() async {
  try {
    isLoadingWalkIns = true;

    walkInSessions.clear();

    final response = await http.get(
      Uri.parse(
        "$baseUrl/orders/restaurants/$restaurantId/sessions?status=OPEN&channel=WALK_IN",
      ),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $authToken",
      },
    );

    final decoded = jsonDecode(response.body);

    if (response.statusCode == 200 &&
        decoded["success"] == true) {

      final model = OnlineSessionResponse.fromJson(decoded);

      walkInSessions = model.data;

      
    }
  } catch (e) {
    showToast("Failed to load walk-in customers", isError: true);
  } finally {
    isLoadingWalkIns = false;
    update();
  }
}

  @override
  void onInit() {
    getUserProfile();
    fetchTables();
    fetchMenus();
    fetchAllPendingSession();
    super.onInit();
   
  }
}
