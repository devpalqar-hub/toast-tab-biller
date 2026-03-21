import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';
import 'package:get/get.dart';
import 'package:toasttab/Screens/BillerDashboard/Service/DashBoardContoller.dart';
import 'package:toasttab/Screens/BillerDashboard/Service/PrinterController.dart';
import 'package:toasttab/Screens/BillerDashboard/Views/Printers/PrinterSettingsDialog.dart';

class AppHeader extends StatelessWidget {
  final String userName;
  final String role;
  final double shiftSales;
  final int activeSessions;

  const AppHeader({
    super.key,
    required this.userName,
    required this.role,
    required this.shiftSales,
    required this.activeSessions,
  });

  @override
  Widget build(BuildContext context) {
    // Register PrinterController if not yet registered
    if (!Get.isRegistered<PrinterController>()) {
      Get.put(PrinterController());
    }

    return GetBuilder<DashboardController>(
      builder: (dash) {
        return GetBuilder<PrinterController>(
          builder: (printer) {
            return Container(
              height: 72.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.08),
                    spreadRadius: 1,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // ── Logo ───────────────────────────────────────────
                  Image.asset('assets/logo.png', width: 40.w, height: 40.h),
                  SizedBox(width: 8.w),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Gastro',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: 'POS',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // ── Printer Status Pill ────────────────────────────
                  _PrinterPill(ctrl: printer),

                  SizedBox(width: 16.w),

                  // ── Notification ───────────────────────────────────
                  Icon(
                    Icons.notifications_none,
                    color: Colors.grey[700],
                    size: 24.w,
                  ),
                  SizedBox(width: 24.w),
                  Container(width: 1.w, height: 28.h, color: Colors.grey[300]),
                  SizedBox(width: 24.w),

                  // ── User Info ──────────────────────────────────────
                  if (dash.userModel != null)
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              dash.userModel!.name ?? "",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              (dash.userModel!.name ?? "")
                                      .replaceAll("_", " ")
                                      .capitalize ??
                                  "",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 24.w),
                          child: Image.asset(
                            'assets/profile.png',
                            width: 40.w,
                            height: 40.h,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// ── Printer Pill Button ───────────────────────────────────────────────────────
class _PrinterPill extends StatelessWidget {
  final PrinterController ctrl;
  const _PrinterPill({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final connected = ctrl.isConnected;
    final hasSaved = ctrl.hasSavedDevice;
    final name = ctrl.selectedPrinter?.name ?? ctrl.savedDeviceName;
    final displayName = name != null
        ? (name.length > 16 ? "${name.substring(0, 15)}…" : name)
        : "No Printer";

    final Color dotColor = connected
        ? const Color(0xFF10B981)
        : hasSaved
        ? const Color(0xFFF59E0B)
        : const Color(0xFFCBD5E1);
    final Color bg = connected
        ? const Color(0xFFECFDF5)
        : hasSaved
        ? const Color(0xFFFFFBEB)
        : const Color(0xFFF1F5F9);
    final Color border = connected
        ? const Color(0xFF10B981).withOpacity(0.3)
        : hasSaved
        ? const Color(0xFFF59E0B).withOpacity(0.3)
        : const Color(0xFFE2E8F0);
    final Color textColor = connected
        ? const Color(0xFF10B981)
        : hasSaved
        ? const Color(0xFFF59E0B)
        : const Color(0xFF94A3B8);

    return GestureDetector(
      onTap: () {
        Get.dialog(
          const PrinterSettingsDialog(),
          barrierDismissible: true,
          barrierColor: Colors.black54,
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(7.r),
          border: Border.all(color: border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Pulsing status dot
            Container(
              width: 7.w,
              height: 7.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: dotColor,
              ),
            ),
            SizedBox(width: 6.w),
            Icon(
              ctrl.selectedPrinter?.connectionType == null
                  ? Icons.print_outlined
                  : ctrl.selectedPrinter!.connectionType == ConnectionType.USB
                  ? Icons.usb_rounded
                  : Icons.bluetooth_rounded,
              size: 13.sp,
              color: textColor,
            ),
            SizedBox(width: 5.w),
            Text(
              displayName,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            SizedBox(width: 3.w),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 13.sp,
              color: textColor.withOpacity(0.7),
            ),
          ],
        ),
      ),
    );
  }
}
