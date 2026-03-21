import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ItemStatusChip extends StatelessWidget {
  final String status;
  const ItemStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final style = _style(status);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: style.bg,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 8.sp,
          fontWeight: FontWeight.w700,
          color: style.text,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  _ChipStyle _style(String s) {
    switch (s.toUpperCase()) {
      case 'PENDING':
        return _ChipStyle(
          bg: const Color(0xFFFFF4EC),
          text: const Color(0xFFF2994A),
        );
      case 'PREPARING':
        return _ChipStyle(
          bg: const Color(0xFFEFF6FF),
          text: const Color(0xFF2F80ED),
        );
      case 'PREPARED':
        return _ChipStyle(
          bg: const Color(0xFFECFDF5),
          text: const Color(0xFF10B981),
        );
      case 'SERVED':
        return _ChipStyle(
          bg: const Color(0xFFF1F5F9),
          text: const Color(0xFF64748B),
        );
      case 'CANCELLED':
        return _ChipStyle(
          bg: const Color(0xFFFEF2F2),
          text: const Color(0xFFEF4444),
        );
      default:
        return _ChipStyle(
          bg: const Color(0xFFF1F5F9),
          text: const Color(0xFF94A3B8),
        );
    }
  }
}

class _ChipStyle {
  final Color bg;
  final Color text;
  const _ChipStyle({required this.bg, required this.text});
}
