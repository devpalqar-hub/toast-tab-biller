import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class AuthController extends GetxController {
  final emailController = TextEditingController();
  final otpController = TextEditingController();

  bool isLoading = false;
  bool isOtpSent = false;

  final String baseUrl = "https://api.pos.palqar.cloud/api/v1";

  void showToast(String message, {bool isError = false}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: isError ? Colors.red : Colors.green,
      textColor: Colors.white,
    );
  }

Future<void> sendOtp() async {
  if (emailController.text.isEmpty) {
    showToast("Please enter email", isError: true);
    return;
  }

  isLoading = true;
  update();

  final url = "$baseUrl/auth/send-otp";

  final body = {
    "email": emailController.text.trim(),
  };

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
    showToast("OTP sent successfully");
  } else {
    showToast(
      data["message"] ?? "Email not found",
      isError: true,
    );
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

    if (response.statusCode == 200) {
      showToast("Login Successful");
    } else {
      showToast(data["message"] ?? "Invalid OTP", isError: true);
    }
  }
}