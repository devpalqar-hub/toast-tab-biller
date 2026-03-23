import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toasttab/Screens/AuthenticationScreen/AuthenticationScreen.dart';
import 'package:toasttab/Screens/BillerDashboard/Service/BillerController.dart';
import 'package:toasttab/Screens/BillerDashboard/Service/DashBoardContoller.dart';
import 'package:toasttab/Screens/BillerDashboard/Service/PrinterController.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';
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
    if (!Get.isRegistered<PrinterController>()) {
      Get.put(PrinterController());
    }

    return GetBuilder<DashboardController>(
      builder: (dash) {
        return GetBuilder<PrinterController>(
          builder: (printer) {
            return Container(
              height: 72.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    spreadRadius: 0,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // ── Logo ───────────────────────────────────────────
                  Image.asset('assets/logo.png', width: 38.w, height: 38.h),
                  SizedBox(width: 8.w),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Gastro',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        TextSpan(
                          text: 'POS',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2F80ED),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // ── Printer Status Pill ────────────────────────────
                  _PrinterPill(ctrl: printer),
                  SizedBox(width: 12.w),

                  // ── Divider ────────────────────────────────────────
                  _VDivider(),
                  SizedBox(width: 12.w),

                  // ── Notification ───────────────────────────────────
                  _IconBtn(
                    icon: Icons.notifications_none_rounded,
                    onTap: () {},
                  ),
                  SizedBox(width: 8.w),

                  // ── Divider ────────────────────────────────────────
                  _VDivider(),
                  SizedBox(width: 12.w),

                  // ── User Info + Logout ─────────────────────────────
                  if (dash.userModel != null) ...[
                    _UserAvatar(name: dash.userModel!.name ?? "U"),
                    SizedBox(width: 9.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          dash.userModel!.name ?? "",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          (dash.userModel!.role ?? "Staff")
                                  .replaceAll("_", " ")
                                  .capitalize ??
                              "",
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: const Color(0xFF94A3B8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 12.w),
                  ],

                  // ── Logout Button ──────────────────────────────────
                  LogoutButton(),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// ── Logout Button ─────────────────────────────────────────────────────────────
class LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.dialog(
          const LogoutDialog(),
          barrierDismissible: true,
          barrierColor: Colors.black.withOpacity(0.45),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF2F2),
          borderRadius: BorderRadius.circular(7.r),
          border: Border.all(color: const Color(0xFFEF4444).withOpacity(0.25)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.logout_rounded,
              size: 13.sp,
              color: const Color(0xFFEF4444),
            ),
            SizedBox(width: 5.w),
            Text(
              "Logout",
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFEF4444),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Logout Confirmation Dialog ────────────────────────────────────────────────
class LogoutDialog extends StatefulWidget {
  const LogoutDialog({super.key});

  @override
  State<LogoutDialog> createState() => _LogoutDialogState();
}

class _LogoutDialogState extends State<LogoutDialog>
    with SingleTickerProviderStateMixin {
  bool _isLoggingOut = false;
  late final AnimationController _animCtrl;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _scaleAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutBack);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  // ── Core logout logic ─────────────────────────────────────────────────────
  Future<void> _performLogout() async {
    setState(() => _isLoggingOut = true);

    // 1. Clear all SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // 2. Disconnect printer if connected
    if (Get.isRegistered<PrinterController>()) {
      final printerCtrl = Get.find<PrinterController>();
      try {
        await printerCtrl.disconnectPrinter();
      } catch (_) {}
    }

    await Get.deleteAll(force: true);

    Get.offAll(
      () => AuthenticationScreen(),
      transition: Transition.fadeIn,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: ScaleTransition(
          scale: _scaleAnim,
          child: Container(
            width: 360.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.14),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            clipBehavior: Clip.hardEdge,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Red accent top strip ──────────────────────────
                Container(
                  height: 4.h,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFEF4444), Color(0xFFF87171)],
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 22.h, 24.w, 20.h),
                  child: Column(
                    children: [
                      // ── Icon ──────────────────────────────────────
                      Container(
                        width: 52.w,
                        height: 52.w,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF2F2),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFEF4444).withOpacity(0.2),
                            width: 1.5,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.logout_rounded,
                          size: 22.sp,
                          color: const Color(0xFFEF4444),
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // ── Title ─────────────────────────────────────
                      Text(
                        "Log out?",
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF0F172A),
                          letterSpacing: -0.3,
                        ),
                      ),
                      SizedBox(height: 8.h),

                      // ── Subtitle ──────────────────────────────────
                      Text(
                        "You'll be signed out of GastroPOS.\nAny unsent orders will not be saved.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: const Color(0xFF64748B),
                          height: 1.5,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 22.h),

                      // ── Divider ───────────────────────────────────
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: const Color(0xFFF1F5F9),
                      ),
                      SizedBox(height: 16.h),

                      // ── Action Buttons ────────────────────────────
                      Row(
                        children: [
                          // Cancel
                          Expanded(
                            child: GestureDetector(
                              onTap: _isLoggingOut ? null : () => Get.back(),
                              child: Container(
                                height: 40.h,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF475569),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),

                          // Confirm Logout
                          Expanded(
                            child: GestureDetector(
                              onTap: _isLoggingOut ? null : _performLogout,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                height: 40.h,
                                decoration: BoxDecoration(
                                  color: _isLoggingOut
                                      ? const Color(0xFFEF4444).withOpacity(0.7)
                                      : const Color(0xFFEF4444),
                                  borderRadius: BorderRadius.circular(8.r),
                                  boxShadow: _isLoggingOut
                                      ? []
                                      : [
                                          BoxShadow(
                                            color: const Color(
                                              0xFFEF4444,
                                            ).withOpacity(0.3),
                                            blurRadius: 8,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                ),
                                alignment: Alignment.center,
                                child: _isLoggingOut
                                    ? SizedBox(
                                        width: 16.w,
                                        height: 16.w,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.logout_rounded,
                                            size: 13.sp,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 5.w),
                                          Text(
                                            "Yes, log out",
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Shared small helpers ──────────────────────────────────────────────────────

class _UserAvatar extends StatelessWidget {
  final String name;
  const _UserAvatar({required this.name});

  String get _initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return "${parts[0][0]}${parts[1][0]}".toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : "U";
  }

  @override
  Widget build(BuildContext context) => Container(
    width: 34.w,
    height: 34.w,
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF2F80ED), Color(0xFF56A0F5)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(9.r),
    ),
    alignment: Alignment.center,
    child: Text(
      _initials,
      style: TextStyle(
        color: Colors.white,
        fontSize: 12.sp,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.5,
      ),
    ),
  );
}

class _VDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Container(width: 1.w, height: 26.h, color: const Color(0xFFE2E8F0));
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 34.w,
      height: 34.w,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: 16.sp, color: const Color(0xFF64748B)),
    ),
  );
}

// ── Printer Pill (unchanged) ──────────────────────────────────────────────────
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
      onTap: () => Get.dialog(
        const PrinterSettingsDialog(),
        barrierDismissible: true,
        barrierColor: Colors.black54,
      ),
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
