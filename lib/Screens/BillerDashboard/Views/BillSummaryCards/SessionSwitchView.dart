import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/utils.dart';
import 'package:toasttab/Screens/BillerDashboard/Service/DashBoardContoller.dart';

class SessionSwitchView extends StatelessWidget {
  SessionSwitchView({super.key});

  DashboardController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        // 1. Filter sessions for the selected table
        final filteredSessions = controller.sessions
            .where((it) => it.tableId == controller.biller.selectedTable!.id)
            .toList();

        // Hide widget if no sessions exist (nothing to switch between)
        if (filteredSessions.isEmpty) return const SizedBox.shrink();

        // 2. "New Bill" = selectedSessionId is null or empty
        final bool isNewBill =
            controller.biller.selectedSessionId == null ||
            controller.biller.selectedSessionId!.isEmpty;

        // 3. Virtual index: sessions occupy 0..n-1, "New Bill" is at index n
        //    So total slots = filteredSessions.length + 1
        final int newBillIndex = filteredSessions.length; // virtual last slot

        int currentIndex = isNewBill
            ? newBillIndex
            : filteredSessions.indexWhere(
                (s) => s.id == controller.biller.selectedSessionId,
              );

        // Safety: if session not found, fall back to first session
        if (!isNewBill && currentIndex == -1) currentIndex = 0;

        final bool canGoLeft = currentIndex > 0;
        final bool canGoRight = currentIndex < newBillIndex;

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F7FF),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ◀ LEFT ARROW
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: Icon(
                  Icons.chevron_left,
                  color: canGoLeft
                      ? const Color(0xFF2F80ED)
                      : Colors.grey.shade400,
                  size: 20.sp,
                ),
                onPressed: canGoLeft
                    ? () {
                        final prevIndex = currentIndex - 1;
                        if (prevIndex == newBillIndex) {
                          // Navigating to "New Bill" slot — shouldn't happen
                          // since newBillIndex is always the rightmost
                        } else {
                          final session = filteredSessions[prevIndex];
                          controller.biller.selectedSession = session;
                          controller.biller.selectedSessionId = session.id!;
                          controller.biller.fetchSessionDetail(session.id!);
                          controller.biller.update();
                        }
                      }
                    : null,
              ),

              // SESSION LABEL
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Text(
                  isNewBill
                      ? "New Bill"
                      : filteredSessions[currentIndex].sessionNumber ??
                            "Session",
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2F80ED),
                  ),
                ),
              ),

              // ▶ RIGHT ARROW
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: Icon(
                  Icons.chevron_right,
                  color: canGoRight
                      ? const Color(0xFF2F80ED)
                      : Colors.grey.shade400,
                  size: 20.sp,
                ),
                onPressed: canGoRight
                    ? () {
                        final nextIndex = currentIndex + 1;
                        if (nextIndex == newBillIndex) {
                          // Navigate to "New Bill" slot
                          controller.biller.selectedSession = null;
                          controller.biller.selectedSessionId = null;
                          controller.biller.billSummary = null;
                          controller.biller.update();
                        } else {
                          final session = filteredSessions[nextIndex];
                          controller.biller.selectedSession = session;
                          controller.biller.selectedSessionId = session.id!;
                          controller.biller.fetchSessionDetail(session.id!);
                          controller.biller.update();
                        }
                      }
                    : null,
              ),
            ],
          ),
        );
      },
    );
  }
}
