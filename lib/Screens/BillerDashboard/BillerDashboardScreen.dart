import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toasttab/Screens/BillerDashboard/Views/AppHeader.dart';
import 'package:toasttab/Screens/BillerDashboard/Views/BillSummaryView.dart';
import 'package:toasttab/Screens/BillerDashboard/Views/MenuListingView.dart';
import 'package:toasttab/Screens/BillerDashboard/Views/TableStatusView.dart';

class BillerdashBoardScreen extends StatelessWidget {
  const BillerdashBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top Header
            AppHeader(
              userName: "Reema",
              role: "Staff",
              shiftSales: 1000.00,
              activeSessions: 5,
            ),

            SizedBox(height: 16.h),

            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 280.w, child: TableStatusView()),

                  // Menu Listing (flexible width, scrollable)
                  Expanded(child: MenuListingView()),

                  // Bill Summary (fixed width)
                  BillSummaryView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
