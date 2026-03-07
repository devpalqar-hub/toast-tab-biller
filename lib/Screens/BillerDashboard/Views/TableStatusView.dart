import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
            width: 300.w,
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 3),
            ),
          );
        }

        if (controller.tables.isEmpty) {
          return SizedBox(
            width: 300.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.table_restaurant_outlined,
                  size: 48.sp,
                  color: Colors.grey.shade400,
                ),
                SizedBox(height: 12.h),
                Text(
                  "No Tables Found",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }

        return Container(
          width: 320.w, // Slightly wider for a comfortable tablet sidebar
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              right: BorderSide(color: Colors.grey.shade200, width: 1),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                spreadRadius: 0,
                blurRadius: 10,
                offset: const Offset(3, 0),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Header Portion ---
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 16.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "TABLE OVERVIEW",
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: const Color(0xFF64748B), // Slate Grey
                      ),
                    ),
                    // Optional: Shows total table count
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        "${controller.tables.length}",
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Divider(color: Colors.grey.shade200, thickness: 1, height: 1),

              // --- Scrollable List of Tables ---
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  itemCount: controller.tables.length,
                  itemBuilder: (context, index) {
                    final table = controller.tables[index];
                    final styles = _getStatusStyle(table.status);

                    return SessionCard(
                      tableName: table.name,
                      status: table.status,
                      sessions: [
                        SessionItem(title: "SE-102", amount: "100.00"),
                        SessionItem(title: "SE-102", amount: "100.00"),
                      ],
                      statusColor: styles["color"] as Color,
                      backgroundColor: styles["bgColor"] as Color,
                      // Pass sessions if they exist in your model: sessions: table.sessions
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Refined, professional color palette
  Map<String, dynamic> _getStatusStyle(String status) {
    switch (status.toLowerCase()) {
      case "billing":
        return {
          "color": const Color(0xFFEF4444), // Modern Red
          "bgColor": const Color(0xFFFEF2F2),
        };
      case "occupied":
        return {
          "color": const Color(0xFFF59E0B), // Modern Amber/Orange
          "bgColor": const Color(0xFFFFFBEB),
        };
      case "available":
        return {
          "color": const Color(0xFF10B981), // Modern Emerald/Green
          "bgColor": const Color(0xFFECFDF5),
        };
      default:
        return {
          "color": const Color(0xFF64748B), // Slate Grey
          "bgColor": const Color(0xFFF8FAFC),
        };
    }
  }
}

class SessionCard extends StatelessWidget {
  final String tableName;
  final String status;
  final Color statusColor;
  final Color backgroundColor;
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: double.infinity, // Automatically fills the parent's padding
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          16.r,
        ), // Slightly tighter radius for a sleeker look
        border: Border.all(
          // Only show colored border if selected, otherwise subtle grey
          color: isSelected ? statusColor : Colors.grey.shade200,
          width: isSelected ? 2.w : 1.w,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03), // Much softer shadow
            spreadRadius: 0,
            blurRadius: 8.r,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Header: Table Name & Status Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                tableName,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A), // Dark Slate
                  letterSpacing: -0.3,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: backgroundColor, // Uses the soft background color
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 8.sp,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),

          // Render Sessions if available
          if (sessions != null && sessions!.isNotEmpty) ...[
            SizedBox(height: 16.h),
            Divider(color: Colors.grey.shade100, height: 1, thickness: 1),
            SizedBox(height: 12.h),
            Column(
              children: sessions!.map((session) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          session.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: session.isActive
                                ? FontWeight.w600
                                : FontWeight.w500,
                            color: session.isActive
                                ? statusColor
                                : const Color(0xFF475569),
                          ),
                        ),
                      ),
                      if (session.amount.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(left: 8.w),
                          child: Text(
                            session.amount,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                              color: session.isActive
                                  ? statusColor
                                  : const Color(0xFF0F172A),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }).toList(),
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
