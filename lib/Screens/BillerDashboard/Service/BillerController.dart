import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:http/http.dart';
import 'package:toasttab/Screens/BillerDashboard/Models/Request/BatchItemRequest.dart';
import 'package:toasttab/Screens/BillerDashboard/Models/Response/CustomerModel.dart';
import 'package:toasttab/Screens/BillerDashboard/Models/Response/MenuModel.dart';
import 'package:toasttab/Screens/BillerDashboard/Models/Response/Ordersession.dart';
import 'package:toasttab/Screens/BillerDashboard/Models/Response/SessionModel.dart';
import 'package:toasttab/Screens/BillerDashboard/Models/Response/TableModel.dart';
import 'package:toasttab/Screens/BillerDashboard/Service/DashBoardContoller.dart';
import 'package:toasttab/main.dart';

class BillerController extends GetxController {
  String? selectedSessionId = "";
  TableData? selectedTable;
  bool isNewSession = false;
  BillSummaryModel? billSummary;
  List<BatchItemModel> newBatchItems = [];
  SessionModel? selectedSession;
  String subTotalAmount = "0";
  String taxAmount = "0";
  String totalAmount = '0';
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  bool claimLoyality = false;
  fetchSessionDetail(String sessionId) async {
    String parms = "";
    if (nameController.text.isNotEmpty) {
      parms = parms + "customerName=${nameController.text.trim()}&";
    }
    if (phoneController.text.isNotEmpty) {
      parms = parms + "customerPhone=${phoneController.text.trim()}&";
    }
    if (emailController.text.isNotEmpty) {
      parms = parms + "customerEmail=${emailController.text.trim()}&";
    }

    if (claimLoyality) {
      parms = parms + "claimedLoyalityPoints=true&";
    }

    final response = await get(
      Uri.parse(
        baseUrl +
            "/orders/restaurants/${restaurantId}/sessions/${selectedSessionId}/bill/preview?$parms",
      ),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $authToken",
      },
    );
    billSummary = null;
    update();
    if (response.statusCode == 200) {
      billSummary = BillSummaryModel.fromJson(
        json.decode(response.body)["data"],
      );
      if (billSummary != null) {
        subTotalAmount = billSummary!.subtotal ?? "0";
        taxAmount = billSummary!.taxAmount ?? "0";
        totalAmount = billSummary!.totalAmount ?? "0";
        nameController.text = billSummary!.session!.customerName ?? "";
        phoneController.text = billSummary!.session!.customerPhone ?? "";
      } else {
        subTotalAmount = "0";
        taxAmount = "0";
        totalAmount = '0';
        emailController.text = "";
        nameController.text = "";
        phoneController.text = "";
      }
      update();
    } else {}
  }

  checkoutBill(String sessionId) async {
    String parms = "";
    if (nameController.text.isNotEmpty) {
      parms = parms + "customerName=${nameController.text.trim()}&";
    }
    if (phoneController.text.isNotEmpty) {
      parms = parms + "customerPhone=${phoneController.text.trim()}&";
    }
    if (emailController.text.isNotEmpty) {
      parms = parms + "customerEmail=${emailController.text.trim()}&";
    }

    if (claimLoyality) {
      parms = parms + "claimedLoyalityPoints=true&";
    }

    final response = await post(
      Uri.parse(
        baseUrl +
            "/orders/restaurants/${restaurantId}/sessions/${selectedSessionId}/bill/",
      ),
      body: json.encode({
        if (nameController.text.isNotEmpty)
          "customerName": nameController.text.trim(),
        if (phoneController.text.isNotEmpty)
          "customerPhone": phoneController.text.trim(),
        if (emailController.text.isNotEmpty)
          "customerEmail": emailController.text.trim(),
        if (claimLoyality &&
            billSummary!.loyalty != null &&
            billSummary!.loyalty!.totalPoints != "0")
          'claimedLoyalityPoints': claimLoyality,
        "guestCount": selectedTable!.seatCount,
      }),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $authToken",
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      billSummary = null;
      selectedSession = null;
      selectedSessionId = null;
      subTotalAmount = "0";
      taxAmount = "0";
      totalAmount = '0';
      emailController.text = "";
      nameController.text = "";
      phoneController.text = "";
      DashboardController ctrl = Get.find();
      ctrl.fetchAllPendingSession();
      ctrl.fetchTables();
      update();
    } else {}
  }

  selectTable(TableData table, List<SessionModel> sessions) {
    DashboardController dbCtrl = Get.find();
    newBatchItems.clear();
    selectedTable = table;
    billSummary = null;

    subTotalAmount = "0";
    taxAmount = "0";
    totalAmount = '0';
    emailController.text = "";
    nameController.text = "";
    phoneController.text = "";
    if (sessions.isNotEmpty) {
      selectedSession = sessions.first;
      selectedSessionId = selectedSession!.id;
      update();
      fetchSessionDetail(sessions.first.id!);
    } else {
      selectedSession = null;
      selectedSessionId = null;
      update();
    }
    dbCtrl.update();
    update();
  }

  addToBatch(MenuModel menu) {
    if (selectedTable == null) {
      return;
    }

    if (newBatchItems.where((it) => it.menuItemId == menu.id).isEmpty) {
      newBatchItems.add(
        BatchItemModel(menuItemId: menu.id, quantity: 1, notes: ""),
      );
    } else {
      for (var data in newBatchItems) {
        if (data.menuItemId == menu.id) {
          data.quantity = data.quantity! + 1;
        }
      }
    }
    update();
  }

  removeFromBatch(MenuModel menu) {
    for (var data in newBatchItems) {
      if (data.menuItemId == menu.id && data.quantity == 1) {
        newBatchItems.remove(data);
        update();
      } else if (data.menuItemId == menu.id) {
        data.quantity = data.quantity! - 1;
      }
    }
    update();
  }

  startSession({required String tableID, int? guestCount}) async {
    final response = await post(
      Uri.parse(baseUrl + "/orders/restaurants/${restaurantId}/sessions"),

      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $authToken",
      },
      body: json.encode({
        "tableId": tableID,
        "channel": "DINE_IN",
        if (guestCount != null) "guestCount": guestCount,
      }),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      DashboardController dashController = Get.find();
      selectedSession = SessionModel.fromJson(
        json.decode(response.body)["data"],
      );
      dashController.sessions.add(selectedSession!);
      selectedSessionId = selectedSession!.id!;
      dashController.fetchAllPendingSession();
      dashController.fetchTables();
      startBatch();
      dashController.update();
    } else {
      print(response.body);
    }
  }

  startBatch() async {
    DashboardController ctrl = Get.find();
    final response = await post(
      Uri.parse(
        baseUrl +
            "/orders/restaurants/${restaurantId}/sessions/${selectedSessionId}/batches",
      ),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $authToken",
      },
      body: json.encode({
        "items": [for (var menu in newBatchItems) menu.toJson()],
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      for (var menu in newBatchItems) {
        var items = ctrl.menus.where((it) => it.id == menu.menuItemId);
        if (items.isEmpty) {
          break;
        } else {
          if (items.first.itemType == "STOCKABLE") {
            items.first.stockCount = items.first.stockCount! - 1;
            if (items.first.stockCount! < 1) {
              items.first.isOutOfStock = true;
              items.first.isAvailable = false;
            }
          }
        }
        update();
        ctrl.update();
      }
      newBatchItems = [];
      fetchSessionDetail(selectedSessionId!);
      update();
    }
  }

  Future<void> cancelBatchItem({
    required String sessionId,
    required String batchId,
    required String itemId,
    required String cancelReason,
  }) async {
    final response = await patch(
      Uri.parse(
        '$baseUrl/orders/restaurants/$restaurantId'
        '/sessions/$sessionId/batches/$batchId/items/$itemId/status',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: json.encode({'status': 'CANCELLED', 'cancelReason': cancelReason}),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      fetchSessionDetail(sessionId);
    }
  }

  /// Cancel an entire session
  Future<void> cancelSession(String sessionId) async {
    final response = await patch(
      Uri.parse(
        '$baseUrl/orders/restaurants/$restaurantId'
        '/sessions/$sessionId/status',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: json.encode({'status': 'CANCELLED'}),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      // Reset biller state
      billSummary = null;
      selectedSession = null;
      selectedSessionId = null;
      subTotalAmount = '0';
      taxAmount = '0';
      totalAmount = '0';
      nameController.clear();
      phoneController.clear();
      emailController.clear();

      final DashboardController ctrl = Get.find();
      ctrl.fetchAllPendingSession();
      ctrl.fetchTables();
      ctrl.update();
      update();
    }
  }

  String getTableName(String input) {
    final match = RegExp(r'\d+').firstMatch(input);
    return match != null ? 'T ${match.group(0)}' : '--:--';
  }
}
