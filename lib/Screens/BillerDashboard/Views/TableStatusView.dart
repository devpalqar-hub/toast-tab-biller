
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:toasttab/Screens/BillerDashboard/Service/DashBoardContoller.dart';

class TableStatusView extends StatelessWidget {
  const TableStatusView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      init: DashboardController(),
      builder: (controller) {
        if (controller.isLoading) {
          return SizedBox(
            width: 260.w,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (controller.tables.isEmpty) {
          return SizedBox(
            width: 260.w,
            child: const Center(child: Text("No Tables Found")),
          );
        }

        return Center(
          child: Container(
            width: 280.w,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
             
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header portion
                 Text(
                    "TABLE OVERVIEW",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff94A3B8),
                    ),
                  ),
                
                SizedBox(height: 8.h),
                Divider(
                  color: Colors.grey.shade300,
                  thickness: 1.w,
               
                  
                ),
                SizedBox(height: 12.h),

                // List of tables
                Expanded(
                
                  child: ListView.separated(
                    itemCount: controller.tables.length,
                    separatorBuilder: (_, __) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final table = controller.tables[index];
                      final statusStyle = _getStatusStyle(table.status);
                      return SessionCard(
                        tableName: table.name,
                        status: table.status,
                        statusColor: statusStyle["color"]!,
                        backgroundColor: statusStyle["bgColor"]!,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Map<String, Color> _getStatusStyle(String status) {
    switch (status.toLowerCase()) {
      case "billing":
        return {"color": Colors.red, "bgColor": Colors.red.withOpacity(0.1)};
      case "occupied":
        return {"color": Colors.orange, "bgColor": Colors.orange.withOpacity(0.1)};
      case "available":
        return {"color": Colors.green, "bgColor": Colors.green.withOpacity(0.1)};
      default:
        return {"color": Colors.grey, "bgColor": Colors.grey.withOpacity(0.1)};
    }
  }
}
class SessionCard extends StatelessWidget {
  final String tableName;
  final String status;
  final Color statusColor;
  final Color backgroundColor; // you can ignore this now if always white
  final List<SessionItem>? sessions;
  final bool isSelected;

  const SessionCard({
    super.key,
    required this.tableName,
    required this.status,
    required this.statusColor,
    required this.backgroundColor,
    this.sessions,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 215.w,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white, // changed to white
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isSelected ? statusColor : statusColor.withOpacity(0.3),
          width: isSelected ? 3.w : 1.5.w,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // shadow position
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                tableName,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
          if (sessions != null && sessions!.isNotEmpty) ...[
            SizedBox(height: 14.h),
            Column(
              children: sessions!
                  .map(
                    (session) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            session.title,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: session.isActive
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: session.isActive
                                  ? statusColor
                                  : Colors.black87,
                            ),
                          ),
                          if (session.amount.isNotEmpty)
                            Text(
                              session.amount,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: session.isActive
                                    ? statusColor
                                    : Colors.black87,
                              ),
                            ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class SessionItem {
  final String title;
  final String amount;
  final bool isActive;

  const SessionItem({
    required this.title,
    required this.amount,
    this.isActive = false,
  });
}