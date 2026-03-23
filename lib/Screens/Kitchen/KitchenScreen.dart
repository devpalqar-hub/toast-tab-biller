import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:toasttab/Screens/BillerDashboard/Views/AppHeader.dart';
import 'package:toasttab/Screens/Kitchen/Service/KitchenController.dart';
import 'Views/KanbanColumn.dart';

class KitchenScreen extends StatelessWidget {
  const KitchenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<KitchenController>(
      init: KitchenController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: const Color(0xFFF1F5F9),
          body: Column(
            children: [
              // ── Top bar ────────────────────────────────
              _TopBar(controller: controller),

              // ── Kanban board ───────────────────────────
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(10.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // PENDING column
                      Expanded(
                        child: KanbanColumn(
                          title: "Pending",
                          sessions: controller.pendingSessions,
                          accentColor: const Color(0xFFF2994A),
                          controller: controller,
                        ),
                      ),
                      SizedBox(width: 8.w),

                      // PREPARING column
                      Expanded(
                        child: KanbanColumn(
                          title: "Preparing",
                          sessions: controller.preparingSessions,
                          accentColor: const Color(0xFF2F80ED),
                          controller: controller,
                        ),
                      ),
                      SizedBox(width: 8.w),

                      // READY column (disappears when billed)
                      Expanded(
                        child: KanbanColumn(
                          title: "Ready",
                          sessions: controller.readySessions,
                          accentColor: const Color(0xFF10B981),
                          controller: controller,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Top Bar ───────────────────────────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  final KitchenController controller;
  const _TopBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 10.h),
      child: Row(
        children: [
          Container(
            width: 30.w,
            height: 30.w,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF4EC),
              borderRadius: BorderRadius.circular(7.r),
            ),
            child: Icon(
              Icons.outdoor_grill_outlined,
              size: 15.sp,
              color: const Color(0xFFF2994A),
            ),
          ),
          SizedBox(width: 10.w),
          Text(
            "Kitchen",
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F172A),
            ),
          ),
          SizedBox(width: 10.w),

          // Summary pills
          _StatPill(
            label: "${controller.pendingSessions.length} pending",
            color: const Color(0xFFF2994A),
          ),
          SizedBox(width: 5.w),
          _StatPill(
            label: "${controller.preparingSessions.length} cooking",
            color: const Color(0xFF2F80ED),
          ),
          SizedBox(width: 5.w),
          _StatPill(
            label: "${controller.readySessions.length} ready",
            color: const Color(0xFF10B981),
          ),

          const Spacer(),

          // Live indicator
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: controller.isConnected
                  ? const Color(0xFFECFDF5)
                  : const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: controller.isConnected
                        ? const Color(0xFF10B981)
                        : const Color(0xFFEF4444),
                  ),
                ),
                SizedBox(width: 4.w),
                Text(
                  controller.isConnected ? "Live" : "Offline",
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    color: controller.isConnected
                        ? const Color(0xFF10B981)
                        : const Color(0xFFEF4444),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 20),
          LogoutButton(),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  final Color color;
  const _StatPill({required this.label, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text(
      label,
      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color),
    ),
  );
}
