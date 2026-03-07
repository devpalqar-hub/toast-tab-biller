import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppHeader extends StatelessWidget {
  final String userName;
  final String role;
  final double shiftSales;
  final int activeSessions;

  const AppHeader({
    super.key,
    required this.userName,
    required this.role,
    required this.shiftSales,
    required this.activeSessions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      height: 72.h,
      child: Row(
        children: [
          // Logo
          Image.asset('assets/logo.png', width: 40.w, height: 40.h),
          SizedBox(width: 8.w),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Gastro',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                  text: 'POS',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 32.w),

          // Search Box (Flexible to avoid overflow)
          Container(
            height: 36.h,
            width: 430.w, // fixed width works now
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              color: Color(0xffF1F5F9),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: Colors.grey, size: 20.w),
                SizedBox(width: 8.w),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search menu, tables, or orders...',
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 140.w),

          // Shift Sales & Active Sessions
          Container(
            padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 6.h),
            height: 48.h,
            width: 228.w,
            decoration: BoxDecoration(
              color: Color(0xffF8FAFC),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: Color(0xffE2E8F0)),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SHIFT SALES',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      '\$${shiftSales.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 16.w),
                Container(width: 1.w, height: 28.h, color: Colors.grey[300]),
                SizedBox(width: 16.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ACTIVE SESSIONS',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      '$activeSessions',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(width: 24.w),

          // Notification Icon
          Icon(Icons.notifications_none, color: Colors.grey[700], size: 24.w),
          SizedBox(width: 24.w),
          Container(
            width: 1.w,
            height: 28.h,
            color: Colors.grey[300],
          ), // User Info
          SizedBox(width: 24.w),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    userName,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    role,
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                  ),
                ],
              ),

              Padding(
                padding: EdgeInsets.only(left: 24.w),
                child: Image.asset(
                  'assets/profile.png',
                  width: 40.w,
                  height: 40.h,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
