import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toasttab/Screens/AuthenticationScreen/AuthenticationScreen.dart';
import 'package:toasttab/Screens/BillerDashboard/Models/Request/BatchItemRequest.dart';
import 'package:toasttab/Screens/BillerDashboard/Models/Response/CustomerModel.dart';
import 'package:toasttab/Screens/BillerDashboard/Models/Response/MenuModel.dart';
import 'package:toasttab/Screens/BillerDashboard/Models/Response/Ordersession.dart';
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

  void showToast(String message, {bool isError = false}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: isError ? Colors.red : Colors.green,
      textColor: Colors.white,
    );
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
    // isLoading = true;
    // update();

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
    log(response.body);

    if (response.statusCode == 200) {
      for (var data in json.decode(response.body)["data"]) {
        sessions.add(SessionModel.fromJson(data));
      }

      update();
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

  @override
  void onInit() {
    getUserProfile();
    fetchTables();
    fetchMenus();
    fetchAllPendingSession();
    super.onInit();
  }
}
