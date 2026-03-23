import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:toasttab/Screens/AuthenticationScreen/Service/AuthenticationController.dart';

class AuthenticationScreen extends StatelessWidget {
  AuthenticationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.put(AuthController());

    // Define standard brand colors for a cohesive look
    const Color primaryColor = Color(0xFF1F89E5);
    const Color surfaceColor = Colors.white;
    const Color backgroundColor = Color(0xFFF8FAFC); // Modern slate background
    const Color inputFillColor = Color(0xFFF1F5F9);
    const Color textColor = Color(0xFF1E293B);
    const Color subtitleColor = Color(0xFF64748B);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            // Widened for tablet, ensuring it looks like a proper modal card
            width: 420.w,
            padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 48.h),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 24.r,
                  spreadRadius: 8.r,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: GetBuilder<AuthController>(
              builder: (_) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // --- Brand Logo Placeholder ---
                    Container(
                      height: 72.h,
                      width: 72.h,
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons
                            .restaurant_menu_rounded, // Restaurant context icon
                        size: 36.sp,
                        color: primaryColor,
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // --- Headers ---
                    Text(
                      "Welcome Back",
                      style: TextStyle(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w800,
                        color: textColor,
                        letterSpacing: -0.5,
                      ),
                    ),

                    SizedBox(height: 8.h),

                    Text(
                      "Log in to manage your floor and kitchen.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: subtitleColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    SizedBox(height: 32.h),

                    // --- Form Area ---
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Email Address",
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                    ),

                    SizedBox(height: 8.h),

                    TextField(
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: inputFillColor,
                        hintText: "name@restaurant.com",
                        hintStyle: TextStyle(
                          color: subtitleColor.withOpacity(0.7),
                        ),
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: subtitleColor,
                          size: 20.sp,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 18.h, // Taller touch target for tablets
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(
                            color: primaryColor,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // --- OTP Area ---
                    if (controller.isOtpSent) ...[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Security Code (OTP)",
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                      ),

                      SizedBox(height: 12.h),

                      Pinput(
                        length: 6,
                        controller: controller.otpController,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        defaultPinTheme: PinTheme(
                          width: 52.w, // Larger boxes for tablet touch
                          height: 56.h,
                          textStyle: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                          decoration: BoxDecoration(
                            color: inputFillColor,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: Colors.transparent),
                          ),
                        ),
                        focusedPinTheme: PinTheme(
                          width: 52.w,
                          height: 56.h,
                          textStyle: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                          decoration: BoxDecoration(
                            color: surfaceColor,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: primaryColor, width: 1.5),
                          ),
                        ),
                      ),

                      SizedBox(height: 32.h),
                    ],

                    // --- Action Button ---
                    SizedBox(
                      width: double.infinity,
                      height: 56.h, // Taller button
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        onPressed: controller.isLoading
                            ? null
                            : controller.isOtpSent
                            ? controller.verifyOtp
                            : controller.sendOtp,
                        child: controller.isLoading
                            ? SizedBox(
                                height: 24.h,
                                width: 24.w,
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    controller.isOtpSent
                                        ? "Verify & Login"
                                        : "Send Secure Code",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Icon(
                                    controller.isOtpSent
                                        ? Icons.check_circle_outline
                                        : Icons.arrow_forward_rounded,
                                    color: Colors.white,
                                    size: 20.sp,
                                  ),
                                ],
                              ),
                      ),
                    ),

                    SizedBox(height: 32.h),

                    // --- Footer ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: subtitleColor,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Add Contact Sales routing here
                          },
                          child: Text(
                            "Contact Sales",
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
