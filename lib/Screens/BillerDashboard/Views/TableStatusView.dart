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
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: Text(
                        "Quick Actions",
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                    ),

                 
                    _QuickActionCard(
                      icon: Icons.person_add_alt_1,
                      title: "New Customer",
                      subtitle: "Create walk-in customer order",
                      color: Color(0xFF2F80ED),
                      onTap: () async {
                        final TextEditingController nameCtrl =
                            TextEditingController();

                        final customerName = await showDialog<String>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              contentPadding: EdgeInsets.zero,
                              content: Container(
                                width: 350.w,
                                padding: EdgeInsets.all(20.w),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 42.w,
                                          height: 42.w,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFEFF6FF),
                                            borderRadius: BorderRadius.circular(
                                              10.r,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.person_add_alt_1,
                                            color: Color(0xFF2563EB),
                                          ),
                                        ),
                                        SizedBox(width: 12.w),
                                        Expanded(
                                          child: Text(
                                            "New Customer",
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFF0F172A),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: 20.h),

                                    Text(
                                      "Customer Name",
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF475569),
                                      ),
                                    ),

                                    SizedBox(height: 8.h),

                                    TextField(
                                      controller: nameCtrl,
                                      autofocus: true,
                                      decoration: InputDecoration(
                                        hintText: "Enter customer name",
                                        hintStyle: TextStyle(
                                          color: const Color(0xFF94A3B8),
                                          fontSize: 12.sp,
                                        ),
                                        filled: true,
                                        fillColor: const Color(0xFFF8FAFC),
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 14.w,
                                          vertical: 12.h,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8.r,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Color(0xFFE2E8F0),
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8.r,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Color(0xFFE2E8F0),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8.r,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Color(0xFF2563EB),
                                            width: 1.5,
                                          ),
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: 20.h),

                                    Row(
                                      children: [
                                        Expanded(
                                          child: OutlinedButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            style: OutlinedButton.styleFrom(
                                              minimumSize: Size(
                                                double.infinity,
                                                42.h,
                                              ),
                                              side: const BorderSide(
                                                color: Color(0xFFE2E8F0),
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                              ),
                                            ),
                                            child: Text(
                                              "Cancel",
                                              style: TextStyle(
                                                color: const Color(0xFFEF4444),
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12.sp,
                                              ),
                                            ),
                                          ),
                                        ),

                                        SizedBox(width: 10.w),

                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(
                                                context,
                                                nameCtrl.text.trim(),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(
                                                0xFF2563EB,
                                              ),
                                              elevation: 0,
                                              minimumSize: Size(
                                                double.infinity,
                                                42.h,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                              ),
                                            ),
                                            child: Text(
                                              "Create",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 12.sp,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );

                        if (customerName == null || customerName.isEmpty)
                          return;

                        controller.biller.selectedTable = null;
                        controller.biller.selectedSession = null;
                        controller.biller.selectedSessionId = null;
                        controller.biller.isCustomerOrder = true;

                        controller.update();

                        await controller.biller.startSession(
                          customerName: customerName,
                        );
                      },
                    ),

                    //
                    SizedBox(height: 10.h),
                    Container(
                      margin: EdgeInsets.only(bottom: 8.h),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              controller.toggleOnlineOrders();
                            },
                            borderRadius: BorderRadius.circular(8.r),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 12.h,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 34.w,
                                    height: 34.w,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEFF6FF),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: const Icon(
                                      Icons.delivery_dining,
                                      color: Color(0xFF2F80ED),
                                    ),
                                  ),

                                  SizedBox(width: 10.w),

                                  Expanded(
                                    child: Text(
                                      "Online Orders",
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF0F172A),
                                      ),
                                    ),
                                  ),

                                  AnimatedRotation(
                                    turns: controller.showOnlineOrders
                                        ? 0.5
                                        : 0,
                                    duration: const Duration(milliseconds: 200),
                                    child: Icon(
                                      Icons.keyboard_arrow_down,
                                      size: 20.sp,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          if (controller.showOnlineOrders)
                            Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(color: Color(0xFFE2E8F0)),
                                ),
                              ),
                              child: Column(
                                children: [
                                  _OnlinePlatformTile(
                                    title: "ONLINE_OWN",
                                    icon: Icons.language,
                                    onTap: () {
                                      controller.selectPlatform("ONLINE_OWN");
                                    },
                                  ),

                                  _OnlinePlatformTile(
                                    title: "UBER_EATS",
                                    icon: Icons.delivery_dining,
                                    onTap: () {
                                      controller.selectPlatform("UBER_EATS");
                                    },
                                  ),

                                  _OnlinePlatformTile(
                                    title: "DOORDASH",
                                    icon: Icons.shopping_bag_outlined,
                                    onTap: () {
                                      controller.selectPlatform("DOORDASH");
                                    },
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),

                    SizedBox(height: 8.h),

                    Divider(
                      height: 1,
                      thickness: 1,
                      color: const Color(0xFFE2E8F0),
                    ),

                    Padding(
                      padding: EdgeInsets.fromLTRB(4.w, 10.h, 4.w, 10.h),
                      child: Row(
                        children: [
                          Text(
                            "Tables",
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                          const Spacer(),
                          _statusDotRow(controller),
                        ],
                      ),
                    ),

                    Divider(
                      height: 1,
                      thickness: 1,
                      color: const Color(0xFFE2E8F0),
                    ),
                    SizedBox(height: 20.h),
                    ...controller.tables.where((table) => table.isActive).map((
                      table,
                    ) {
                      final style = _statusStyle(table.status);

                      final isSelected =
                          controller.biller.selectedTable?.id == table.id;

                      final tableSessions = controller.sessions
                          .where((s) => s.tableId == table.id)
                          .toList();

                      return _CompactTableRow(
                        tableName: table.name,
                        tableStatus: table.status,
                        statusColor: style.color,
                        statusBg: style.bg,
                        sessionCount: tableSessions.length,
                        guestCount: table.seatCount,
                        isSelected: isSelected,
                        onTap: () {
                          controller.biller.selectTable(table, tableSessions);
                          controller.update();
                        },
                      );
                    }).toList(),
                  ],
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

class _OptionButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _OptionButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
          decoration: BoxDecoration(
            color: isSelected ? Color(0xFF2F80ED) : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(6.r),
            border: Border.all(
              color: isSelected ? Color(0xFF2F80ED) : const Color(0xFFE2E8F0),
              width: 1.w,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF475569),
                letterSpacing: -0.1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Container(
              width: 38.w,
              height: 38.w,
              decoration: BoxDecoration(
                color: color.withOpacity(.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(icon, color: color, size: 18.sp),
            ),

            SizedBox(width: 10.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              Icons.arrow_forward_ios,
              size: 13.sp,
              color: Color(0xFF64748B),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnlinePlatformTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _OnlinePlatformTile({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: Color(0xFF2F80ED)),

            SizedBox(width: 10.w),

            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF334155),
                ),
              ),
            ),

            Icon(
              Icons.arrow_forward_ios,
              size: 10.sp,
              color: Color(0xFF94A3B8),
            ),
          ],
        ),
      ),
    );
  }
}
