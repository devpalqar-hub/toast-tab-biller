import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CancelItemDialog extends StatefulWidget {
  final String itemName;
  final void Function(String reason) onConfirm;

  const CancelItemDialog({
    super.key,
    required this.itemName,
    required this.onConfirm,
  });

  static void show(
    BuildContext context, {
    required String itemName,
    required void Function(String reason) onConfirm,
  }) {
    showDialog(
      context: context,
      barrierColor: Colors.black45,
      builder: (_) =>
          CancelItemDialog(itemName: itemName, onConfirm: onConfirm),
    );
  }

  @override
  State<CancelItemDialog> createState() => _CancelItemDialogState();
}

class _CancelItemDialogState extends State<CancelItemDialog> {
  // Quick-select reasons
  static const _reasons = [
    'Customer changed mind',
    'Wrong item ordered',
    'Allergy concern',
    'Out of stock',
    'Other',
  ];

  String _selected = 'Customer changed mind';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        width: 320.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(14.w, 14.h, 10.w, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 30.w,
                    height: 30.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(7.r),
                    ),
                    child: Icon(
                      Icons.remove_circle_outline,
                      size: 15.sp,
                      color: const Color(0xFFEF4444),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Cancel item?",
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          widget.itemName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Padding(
                      padding: EdgeInsets.all(4.w),
                      child: Icon(
                        Icons.close,
                        size: 16.sp,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: Divider(height: 18.h, color: const Color(0xFFE2E8F0)),
            ),

            // ── Reason chips ─────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 4.h),
              child: Text(
                "Reason",
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(14.w, 6.h, 14.w, 0),
              child: Wrap(
                spacing: 6.w,
                runSpacing: 6.h,
                children: _reasons.map((r) {
                  final active = _selected == r;
                  return GestureDetector(
                    onTap: () => setState(() => _selected = r),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 120),
                      padding: EdgeInsets.symmetric(
                        horizontal: 9.w,
                        vertical: 5.h,
                      ),
                      decoration: BoxDecoration(
                        color: active
                            ? const Color(0xFFFEF2F2)
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(
                          color: active
                              ? const Color(0xFFEF4444).withOpacity(0.4)
                              : Colors.transparent,
                        ),
                      ),
                      child: Text(
                        r,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: active
                              ? const Color(0xFFEF4444)
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            SizedBox(height: 14.h),

            // ── Actions ──────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 14.h),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        height: 36.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(7.r),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Keep item",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        widget.onConfirm(_selected);
                      },
                      child: Container(
                        height: 36.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444),
                          borderRadius: BorderRadius.circular(7.r),
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.remove_circle_outline,
                              size: 13.sp,
                              color: Colors.white,
                            ),
                            SizedBox(width: 5.w),
                            Text(
                              "Cancel item",
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 3. CancelSessionDialog  —  confirm before cancelling the whole session
//    Usage:
//      CancelSessionDialog.show(context,
//        sessionNumber: "A1B2C3",
//        onConfirm: () => controller.biller.cancelSession(sessionId),
//      );
// ─────────────────────────────────────────────────────────────────────────────

class CancelSessionDialog extends StatelessWidget {
  final String sessionNumber;
  final VoidCallback onConfirm;

  const CancelSessionDialog({
    super.key,
    required this.sessionNumber,
    required this.onConfirm,
  });

  static void show(
    BuildContext context, {
    required String sessionNumber,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      barrierColor: Colors.black45,
      builder: (_) => CancelSessionDialog(
        sessionNumber: sessionNumber,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        width: 300.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Header ──────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(14.w, 16.h, 14.w, 0),
              child: Column(
                children: [
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      Icons.cancel_outlined,
                      size: 20.sp,
                      color: const Color(0xFFEF4444),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "Cancel session?",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    "Session $sessionNumber and all its orders\nwill be permanently cancelled.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: const Color(0xFF64748B),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: Divider(height: 20.h, color: const Color(0xFFE2E8F0)),
            ),

            // ── Actions ──────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 14.h),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        height: 38.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(7.r),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Keep session",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        onConfirm();
                      },
                      child: Container(
                        height: 38.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444),
                          borderRadius: BorderRadius.circular(7.r),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Yes, cancel",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
