import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:toasttab/Screens/Kitchen/Models/KitchenBatch.dart';
import 'package:toasttab/Screens/Kitchen/Service/KitchenController.dart';
import 'Views/BatchTicket.dart';

class KitchenScreen extends StatelessWidget {
  const KitchenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<KitchenController>(
      init: KitchenController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          body: Column(
            children: [
              // ── Top Bar ──────────────────────────────────
              _TopBar(controller: controller),

              // ── Filter Tabs ───────────────────────────────
              _FilterBar(controller: controller),

              Divider(height: 1, thickness: 1, color: const Color(0xFFE2E8F0)),

              // ── Body ─────────────────────────────────────
              Expanded(
                child: controller.filteredBatches.isEmpty
                    ? _EmptyState(filter: controller.activeFilter)
                    : ListView.builder(
                        padding: EdgeInsets.all(12.w),
                        itemCount: controller.filteredBatches.length,
                        itemBuilder: (_, i) => BatchTicket(
                          batch: controller.filteredBatches[i],
                          controller: controller,
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
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 12.h),
      child: Row(
        children: [
          // Kitchen icon
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF4EC),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.outdoor_grill_outlined,
              size: 16.sp,
              color: const Color(0xFFF2994A),
            ),
          ),
          SizedBox(width: 10.w),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Kitchen",
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
                  letterSpacing: -0.2,
                ),
              ),
              Text(
                "${controller.batches.length} tickets",
                style: TextStyle(
                  fontSize: 11.sp,
                  color: const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),

          const Spacer(),

          // Connection dot
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
        ],
      ),
    );
  }
}

// ── Filter Bar ────────────────────────────────────────────────────────────────
class _FilterBar extends StatelessWidget {
  final KitchenController controller;
  const _FilterBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 10.h),
      child: Row(
        children: [
          _Tab(
            label: "All",
            count: controller.batches.length,
            active: controller.activeFilter == KitchenFilter.all,
            onTap: () => controller.setFilter(KitchenFilter.all),
          ),
          SizedBox(width: 6.w),
          _Tab(
            label: "Pending",
            count: controller.pendingCount,
            active: controller.activeFilter == KitchenFilter.pending,
            activeColor: const Color(0xFFF2994A),
            onTap: () => controller.setFilter(KitchenFilter.pending),
          ),
          SizedBox(width: 6.w),
          _Tab(
            label: "Ready",
            count: controller.readyCount,
            active: controller.activeFilter == KitchenFilter.ready,
            activeColor: const Color(0xFF10B981),
            onTap: () => controller.setFilter(KitchenFilter.ready),
          ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final int count;
  final bool active;
  final Color activeColor;
  final VoidCallback onTap;

  const _Tab({
    required this.label,
    required this.count,
    required this.active,
    this.activeColor = const Color(0xFF2F80ED),
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: active
              ? activeColor.withOpacity(0.1)
              : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(
            color: active ? activeColor.withOpacity(0.4) : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: active ? activeColor : const Color(0xFF64748B),
              ),
            ),
            SizedBox(width: 5.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: active
                    ? activeColor.withOpacity(0.15)
                    : const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                "$count",
                style: TextStyle(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w700,
                  color: active ? activeColor : const Color(0xFF94A3B8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Empty State ───────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final KitchenFilter filter;
  const _EmptyState({required this.filter});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 36.sp,
            color: const Color(0xFFCBD5E1),
          ),
          SizedBox(height: 10.h),
          Text(
            filter == KitchenFilter.ready
                ? "No ready tickets"
                : filter == KitchenFilter.pending
                ? "No pending tickets"
                : "No tickets yet",
            style: TextStyle(
              fontSize: 13.sp,
              color: const Color(0xFF94A3B8),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            "New orders will appear here in real-time",
            style: TextStyle(fontSize: 11.sp, color: const Color(0xFFCBD5E1)),
          ),
        ],
      ),
    );
  }
}
