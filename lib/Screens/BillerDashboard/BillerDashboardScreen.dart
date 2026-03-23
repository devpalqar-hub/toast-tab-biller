import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/instance_manager.dart';
import 'package:toasttab/Screens/BillerDashboard/Service/BillerController.dart';
import 'package:toasttab/Screens/BillerDashboard/Service/DashBoardContoller.dart';
import 'package:toasttab/Screens/BillerDashboard/Service/RoomController.dart';
import 'package:toasttab/Screens/BillerDashboard/Views/AppHeader.dart';
import 'package:toasttab/Screens/BillerDashboard/Views/BillSummaryView.dart';
import 'package:toasttab/Screens/BillerDashboard/Views/MenuListingView.dart';
import 'package:toasttab/Screens/BillerDashboard/Views/TableStatusView.dart';

class BillerdashBoardScreen extends StatelessWidget {
  BillerdashBoardScreen({super.key});
  DashboardController biller = Get.put(DashboardController());
  RoomController roomController = Get.put(RoomController());


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
              child: GetBuilder<BillerController>(
                builder: (__) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 280.w, child: TableStatusView()),

                      // Menu Listing (flexible width, scrollable)
                      Expanded(child: MenuListingView()),

                      // Bill Summary (fixed width)
                      Container(
                        height: double.infinity,
                        child: BillSummaryView(),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
