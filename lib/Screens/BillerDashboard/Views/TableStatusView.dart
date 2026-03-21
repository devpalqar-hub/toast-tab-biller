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
            width: 240.w,
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }

        if (controller.tables.isEmpty) {
          return SizedBox(
            width: 240.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.table_restaurant_outlined,
                  size: 32.sp,
                  color: const Color(0xFFCBD5E1),
                ),
                SizedBox(height: 6.h),
                Text(
                  "No tables",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          );
        }

        return Container(
          width: 240.w,
          color: Colors.white,
          child: Column(
            children: [
              // ── Header ──────────────────────────────────────
              Container(
                color: Colors.white,
                padding: EdgeInsets.fromLTRB(12.w, 14.h, 12.w, 10.h),
                child: Row(
                  children: [
                    Text(
                      "Tables",
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                        letterSpacing: -0.2,
                      ),
                    ),
                    const Spacer(),
                    // Status dots summary
                    _statusDotRow(controller),
                  ],
                ),
              ),
              Divider(height: 1, thickness: 1, color: const Color(0xFFE2E8F0)),

              // ── List ─────────────────────────────────────────
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                  itemCount: controller.tables.length,
                  itemBuilder: (context, index) {
                    final table = controller.tables[index];
                    final style = _statusStyle(table.status ?? '');
                    final isSelected =
                        controller.biller.selectedTable?.id == table.id;
                    final tableSessions = controller.sessions
                        .where((s) => s.tableId == table.id)
                        .toList();
                    final sessionCount = tableSessions.length;
                    final activeSession = tableSessions.isNotEmpty
                        ? tableSessions.firstWhere(
                            (s) =>
                                s.status?.toLowerCase() == 'open' ||
                                s.status?.toLowerCase() == 'active',
                            orElse: () => tableSessions.first,
                          )
                        : null;

                    return _CompactTableRow(
                      tableName: table.name ?? '—',
                      tableStatus: table.status ?? '',
                      statusColor: style.color,
                      statusBg: style.bg,
                      sessionCount: sessionCount,
                      guestCount: activeSession?.guestCount,
                      isSelected: isSelected,
                      onTap: () {
                        controller.biller.selectTable(table, tableSessions);
                        controller.update();
                      },
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

  Widget _statusDotRow(controller) {
    final counts = {'available': 0, 'occupied': 0, 'billing': 0};
    for (final t in controller.tables) {
      final s = (t.status ?? '').toLowerCase();
      if (counts.containsKey(s)) counts[s] = counts[s]! + 1;
    }
    return Row(
      children: [
        _MiniDot(color: const Color(0xFF10B981), count: counts['available']!),
        SizedBox(width: 6.w),
        _MiniDot(color: const Color(0xFFF59E0B), count: counts['occupied']!),
        SizedBox(width: 6.w),
        _MiniDot(color: const Color(0xFFEF4444), count: counts['billing']!),
      ],
    );
  }

  _StatusStyle _statusStyle(String status) {
    switch (status.toLowerCase()) {
      case 'billing':
        return _StatusStyle(
          color: const Color(0xFFEF4444),
          bg: const Color(0xFFFEF2F2),
        );
      case 'occupied':
        return _StatusStyle(
          color: const Color(0xFFF59E0B),
          bg: const Color(0xFFFFFBEB),
        );
      case 'available':
        return _StatusStyle(
          color: const Color(0xFF10B981),
          bg: const Color(0xFFECFDF5),
        );
      default:
        return _StatusStyle(
          color: const Color(0xFF94A3B8),
          bg: const Color(0xFFF1F5F9),
        );
    }
  }
}

// ── Compact Row Card ──────────────────────────────────────────────────────────
class _CompactTableRow extends StatelessWidget {
  final String tableName;
  final String tableStatus;
  final Color statusColor;
  final Color statusBg;
  final int sessionCount;
  final int? guestCount;
  final bool isSelected;
  final VoidCallback onTap;

  const _CompactTableRow({
    required this.tableName,
    required this.tableStatus,
    required this.statusColor,
    required this.statusBg,
    required this.sessionCount,
    this.guestCount,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        margin: EdgeInsets.only(bottom: 5.h),
        decoration: BoxDecoration(
          color: isSelected ? statusBg : Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected ? statusColor : const Color(0xFFE2E8F0),
            width: isSelected ? 1.5.w : 1.w,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          child: Row(
            children: [
              // Status indicator bar (left accent)
              Container(
                width: 3.w,
                height: 28.h,
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(width: 9.w),

              // Table name
              Expanded(
                child: Text(
                  tableName,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0F172A),
                    letterSpacing: -0.1,
                  ),
                ),
              ),

              // Session count pill (only if sessions exist)
              if (sessionCount > 0) ...[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    "$sessionCount",
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ),
                SizedBox(width: 6.w),
              ],

              // Guest count (icon + number, only if available)
              if (guestCount != null && guestCount! > 0) ...[
                Icon(
                  Icons.people_outline,
                  size: 11.sp,
                  color: const Color(0xFFCBD5E1),
                ),
                SizedBox(width: 2.w),
                Text(
                  "$guestCount",
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: const Color(0xFFCBD5E1),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 6.w),
              ],

              // Status badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  _statusLabel(tableStatus),
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w700,
                    color: statusColor,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _statusLabel(String s) {
    switch (s.toLowerCase()) {
      case 'available':
        return 'Free';
      case 'occupied':
        return 'Active';
      case 'billing':
        return 'Bill';
      default:
        return s;
    }
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────
class _MiniDot extends StatelessWidget {
  final Color color;
  final int count;
  const _MiniDot({required this.color, required this.count});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      SizedBox(width: 3),
      Text(
        "$count",
        style: TextStyle(
          fontSize: 11,
          color: const Color(0xFF94A3B8),
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );
}

class _StatusStyle {
  final Color color;
  final Color bg;
  const _StatusStyle({required this.color, required this.bg});
}
