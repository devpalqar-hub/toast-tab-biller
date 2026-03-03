import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:toasttab/Screens/AuthenticationScreen/Service/AuthenticationController.dart';


class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.put(AuthController());

    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 340.w,
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 15.r,
                  offset: const Offset(0, 5),
                )
              ],
            ),
            child: GetBuilder<AuthController>(
              builder: (_) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                  
                    Text(
                      "Welcome back",
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    SizedBox(height: 8.h),

                    Text(
                      "Log in to manage your floor and kitchen.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey,
                      ),
                    ),

                    SizedBox(height: 25.h),

                    Text(
                      "Login with Otp",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff64748B),
                      ),
                    ),
                      SizedBox(height: 10.h),
                   Divider(
                      height: 2.h,
                      thickness: 1,
                      color: Color(0xff1F89E5),
                    ),
                      SizedBox(height: 25.h),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Email Address",
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    SizedBox(height: 6.h),

                    TextField(
                      controller: controller.emailController,
                      decoration: InputDecoration(
                        hintText: "name@restaurant.com",hintStyle: TextStyle(color: Colors.grey),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 14.h),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.r),
                          borderSide: BorderSide(color: Color(0xffE2E8F0)),
                        ),
                      ),
                    ),

                    SizedBox(height: 20.h),

             
                    if (controller.isOtpSent) ...[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Enter OTP",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      SizedBox(height: 10.h),

                      Pinput(
                        length: 6,
                        controller: controller.otpController,
                        defaultPinTheme: PinTheme(
                          width: 45.w,
                          height: 49.h,
                          textStyle: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),
                    ],

        
                    SizedBox(
                      width: double.infinity,
                      height: 52.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1F89E5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                        onPressed: controller.isLoading
                            ? null
                            : controller.isOtpSent
                                ? controller.verifyOtp
                                : controller.sendOtp,
                        child: controller.isLoading
                            ? SizedBox(
                                height: 20.h,
                                width: 20.w,
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                controller.isOtpSent
                                    ? "Verify OTP"
                                    : "Send OTP",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),

                    SizedBox(height: 20.h),

                    
                    Text(
                      "Don't have an account? Contact Sales",
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.grey,
                      ),
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