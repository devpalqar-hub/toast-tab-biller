import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toasttab/Screens/Kitchen/Models/KitchenBatch.dart';
import 'package:toasttab/Screens/Kitchen/Service/KitchenController.dart';
import 'ItemRow.dart';

class SessionCard extends StatelessWidget {
  final KitchenSession session;
  final KitchenController controller;
  final Color accentColor;

  const SessionCard({
    super.key,
    required this.session,
    required this.controller,
    required this.accentColor,
  });

  Color _timerColor() {
    final m = session.oldestElapsed;
    if (m >= 15) return const Color(0xFFEF4444);
    if (m >= 8) return const Color(0xFFF2994A);
    return accentColor;
  }

  @override
  Widget build(BuildContext context) {
    final tc = _timerColor();
    final isBilledFading = session.isBilled;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 400),
      opacity: isBilledFading ? 0.3 : 1.0,
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Card header ──────────────────────────────
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
              color: accentColor.withOpacity(0.06),
              child: Row(
                children: [
                  // Left accent
                  Container(
                    width: 3.w,
                    height: 24.h,
                    decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  SizedBox(width: 8.w),

                  // Table name
                  Text(
                    session.tableName.isNotEmpty ? session.tableName : "Table",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(width: 5.w),

                  // Session number badge — shows human-readable number
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.w,
                      vertical: 1.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(3.r),
                    ),
                    child: Text(
                      // e.g.  "S · A1B2C3"
                      "S · ${session.sessionNumber}",
                      style: TextStyle(
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Timer
                  Row(
                    children: [
                      Icon(Icons.timer_outlined, size: 10.sp, color: tc),
                      SizedBox(width: 2.w),
                      Text(
                        "${session.oldestElapsed}m",
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                          color: tc,
                        ),
                      ),
                    ],
                  ),

                  // Billed indicator
                  if (isBilledFading) ...[
                    SizedBox(width: 6.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.w,
                        vertical: 1.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(3.r),
                      ),
                      child: Text(
                        "Billed",
                        style: TextStyle(
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // ── Batches + items ───────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(10.w, 6.h, 10.w, 6.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: session.batches.map((batch) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Batch label (only if >1 batch)
                      if (session.batches.length > 1)
                        Padding(
                          padding: EdgeInsets.only(bottom: 3.h),
                          child: Text(
                            batch.batchNumber,
                            style: TextStyle(
                              fontSize: 8.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFCBD5E1),
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ...batch.items.map(
                        (item) => ItemRow(
                          item: item,
                          sessionId: session.sessionId,
                          batchId: batch.batchId,
                          controller: controller,
                        ),
                      ),
                      if (session.batches.indexOf(batch) <
                          session.batches.length - 1)
                        Divider(
                          height: 8.h,
                          thickness: 0.5,
                          color: const Color(0xFFE2E8F0),
                        ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
