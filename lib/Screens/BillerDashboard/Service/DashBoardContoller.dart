import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toasttab/Screens/BillerDashboard/Model/TableModel.dart';
import 'package:toasttab/main.dart';

class DashboardController extends GetxController {
  bool isLoading = false;
  List<TableData> tables = [];

  void showToast(String message, {bool isError = false}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: isError ? Colors.red : Colors.green,
      textColor: Colors.white,
    );
  }

  Future<void> fetchTables() async {
    isLoading = true;
    update();

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

  @override
  void onInit() {
    fetchTables();
    super.onInit();
  }
}
