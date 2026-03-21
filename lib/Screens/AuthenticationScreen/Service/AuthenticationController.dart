import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toasttab/Screens/BillerDashboard/BillerDashboardScreen.dart';
import 'package:toasttab/Screens/BillerDashboard/Service/DashBoardContoller.dart';
import 'package:toasttab/Screens/Kitchen/KitchenScreen.dart';
import 'package:toasttab/main.dart';

class AuthController extends GetxController {
  final emailController = TextEditingController(
    text: "sabarinathp.dev@gmail.com",
  );
  final otpController = TextEditingController(text: "759409");

  bool isLoading = false;
  bool isOtpSent = false;

  void showToast(String message, {bool isError = false}) {}

  Future<void> sendOtp() async {
    if (emailController.text.isEmpty) {
      showToast("Please enter email", isError: true);
      return;
    }

    isLoading = true;
    update();

    final url = "$baseUrl/auth/send-otp";

    final body = {"email": emailController.text.trim()};

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    isLoading = false;
    update();

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["success"] == true) {
      isOtpSent = true;
      update();
      //
    } else {
      //showToast(
      //data["message"] ?? "Email not found",
      // isError: true,
      //);
    }
  }

  Future<void> verifyOtp() async {
    if (otpController.text.length != 6) {
      showToast("Enter valid 6 digit OTP", isError: true);
      return;
    }

    isLoading = true;
    update();

    final url = "$baseUrl/auth/verify-otp";

    final body = {
      "email": emailController.text.trim(),
      "otp": otpController.text.trim(),
    };

    log("URL: $url");

    log("Request Body: ${jsonEncode(body)}");

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    log("Status Code: ${response.statusCode}");
    log("Response Body: ${response.body}");

    isLoading = false;
    update();

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["success"] == true) {
      final resID = data["data"]["user"]["restaurant"]["id"];
      final restaurantName = data["data"]["user"]["restaurant"]["name"];
      final accessToken = data["data"]["accessToken"];

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString("restaurantId", resID);
      await prefs.setString("restaurantName", restaurantName);
      await prefs.setString("accessToken", accessToken);
      authToken = accessToken;
      restaurantId = resID;

      //showToast("Login Successful");
      Get.offAll(() => BillerdashBoardScreen());

      log("Saved Restaurant ID: $restaurantId");
      log("Saved Restaurant Name: $restaurantName");
    }
  }
}
