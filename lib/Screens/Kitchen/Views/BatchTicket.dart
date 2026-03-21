import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toasttab/Screens/Kitchen/Models/KitchenBatch.dart';
import 'package:toasttab/Screens/Kitchen/Service/KitchenController.dart';
import 'ItemStatusChip.dart';

class BatchTicket extends StatelessWidget {
  final KitchenBatch batch;
  final KitchenController controller;

  const BatchTicket({super.key, required this.batch, required this.controller});

  // Ticket border color based on urgency
  Color _urgencyColor() {
    if (batch.isReady) return const Color(0xFF10B981);
    if (batch.elapsedMinutes >= 15) return const Color(0xFFEF4444);
    if (batch.elapsedMinutes >= 8) return const Color(0xFFF2994A);
    return const Color(0xFF2F80ED);
  }

  @override
  Widget build(BuildContext context) {
    final urgency = _urgencyColor();

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Ticket Header ──────────────────────────────
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            color: urgency.withOpacity(0.07),
            child: Row(
              children: [
                // Urgency bar
                Container(
                  width: 3.w,
                  height: 28.h,
                  decoration: BoxDecoration(
                    color: urgency,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                SizedBox(width: 9.w),

                // Table + batch info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Table ${batch.tableId.substring(0, 4).toUpperCase()}",
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0F172A),
                              letterSpacing: -0.2,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              batch.batchNumber,
                              style: TextStyle(
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 10.sp,
                            color: const Color(0xFF94A3B8),
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            batch.createdByName,
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: const Color(0xFF94A3B8),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 10.sp,
                            color: const Color(0xFF94A3B8),
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            batch.sessionNumber,
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: const Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Timer + ready badge
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.timer_outlined, size: 10.sp, color: urgency),
                        SizedBox(width: 2.w),
                        Text(
                          "${batch.elapsedMinutes}m",
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                            color: urgency,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h),
                    if (batch.isReady)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECFDF5),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          "Ready",
                          style: TextStyle(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF10B981),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          Divider(height: 1, thickness: 1, color: const Color(0xFFE2E8F0)),

          // ── Items ──────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            child: Column(
              children: batch.items.map((item) {
                final next = controller.nextStatus(item.status);
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: Row(
                    children: [
                      // Qty bubble
                      Container(
                        width: 22.w,
                        height: 22.w,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "×${item.quantity}",
                          style: TextStyle(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),

                      // Item name
                      Expanded(
                        child: Text(
                          item.name,
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                            color:
                                item.status == 'SERVED' ||
                                    item.status == 'CANCELLED'
                                ? const Color(0xFFCBD5E1)
                                : const Color(0xFF0F172A),
                            decoration: item.status == 'CANCELLED'
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                      ),

                      // Status chip
                      ItemStatusChip(status: item.status),

                      // Action button (advance status)
                      if (next != null) ...[
                        SizedBox(width: 6.w),
                        GestureDetector(
                          onTap: () => controller.updateItemStatus(
                            batchId: batch.batchId,
                            itemId: item.itemId,
                            newStatus: next,
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: _nextBtnColor(next).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(5.r),
                              border: Border.all(
                                color: _nextBtnColor(next).withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              _nextBtnLabel(next),
                              style: TextStyle(
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w700,
                                color: _nextBtnColor(next),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Color _nextBtnColor(String next) {
    switch (next) {
      case 'PREPARING':
        return const Color(0xFF2F80ED);
      case 'PREPARED':
        return const Color(0xFF10B981);
      case 'SERVED':
        return const Color(0xFF64748B);
      default:
        return const Color(0xFF94A3B8);
    }
  }

  String _nextBtnLabel(String next) {
    switch (next) {
      case 'PREPARING':
        return 'Start';
      case 'PREPARED':
        return 'Done';
      case 'SERVED':
        return 'Served';
      default:
        return next;
    }
  }
}
