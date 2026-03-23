import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toasttab/Screens/Kitchen/Models/KitchenBatch.dart';
import 'package:toasttab/Screens/Kitchen/Service/KitchenController.dart';
import 'SessionCard.dart';

class KanbanColumn extends StatelessWidget {
  final String title;
  final List<KitchenSession> sessions;
  final Color accentColor;
  final KitchenController controller;

  const KanbanColumn({
    super.key,
    required this.title,
    required this.sessions,
    required this.accentColor,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Column header ──────────────────────────────
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 9.h),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.07),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.r),
                topRight: Radius.circular(10.r),
              ),
              border: Border(
                bottom: BorderSide(color: const Color(0xFFE2E8F0)),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: accentColor,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 6.w),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                    letterSpacing: 0.2,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    "${sessions.length}",
                    style: TextStyle(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w700,
                      color: accentColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Cards ──────────────────────────────────────
          Expanded(
            child: sessions.isEmpty
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Text(
                        "No tickets",
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: const Color(0xFFCBD5E1),
                        ),
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(8.w),
                    itemCount: sessions.length,
                    itemBuilder: (_, i) => SessionCard(
                      session: sessions[i],
                      controller: controller,
                      accentColor: accentColor,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
