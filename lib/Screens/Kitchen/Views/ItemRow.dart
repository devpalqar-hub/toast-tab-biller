import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toasttab/Screens/Kitchen/Models/KitchenBatch.dart';
import 'package:toasttab/Screens/Kitchen/Service/KitchenController.dart';

class ItemRow extends StatelessWidget {
  final KitchenBatchItem item;
  final String sessionId;
  final String batchId;
  final KitchenController controller;

  const ItemRow({
    super.key,
    required this.item,
    required this.sessionId,
    required this.batchId,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final next = controller.nextStatus(item.status);
    final isDone = item.status == 'SERVED' || item.status == 'CANCELLED';

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.h),
      child: Row(
        children: [
          // Qty
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(4.r),
            ),
            alignment: Alignment.center,
            child: Text(
              "×${item.quantity}",
              style: TextStyle(
                fontSize: 8.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF64748B),
              ),
            ),
          ),
          SizedBox(width: 6.w),

          // Name
          Expanded(
            child: Text(
              item.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                color: isDone
                    ? const Color(0xFFCBD5E1)
                    : const Color(0xFF0F172A),
                decoration: item.status == 'CANCELLED'
                    ? TextDecoration.lineThrough
                    : null,
              ),
            ),
          ),

          // Status dot
          Container(
            width: 6,
            height: 6,
            margin: EdgeInsets.only(right: 5.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _dotColor(item.status),
            ),
          ),

          // Action button
          if (next != null)
            GestureDetector(
              onTap: () => controller.updateItemStatus(
                sessionId: sessionId,
                batchId: batchId,
                batchItemId: item.batchItemId,
                newStatus: next,
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: _btnColor(next).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4.r),
                  border: Border.all(color: _btnColor(next).withOpacity(0.3)),
                ),
                child: Text(
                  _btnLabel(next),
                  style: TextStyle(
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w700,
                    color: _btnColor(next),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _dotColor(String s) {
    switch (s) {
      case 'PENDING':
        return const Color(0xFFF2994A);
      case 'PREPARING':
        return const Color(0xFF2F80ED);
      case 'PREPARED':
        return const Color(0xFF10B981);
      case 'SERVED':
        return const Color(0xFFCBD5E1);
      case 'CANCELLED':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFFCBD5E1);
    }
  }

  Color _btnColor(String next) {
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

  String _btnLabel(String next) {
    switch (next) {
      case 'PREPARING':
        return 'Start';
      case 'PREPARED':
        return 'Done';
      case 'SERVED':
        return 'Serve';
      default:
        return next;
    }
  }
}
