import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:toasttab/Screens/BillerDashboard/Models/Response/CustomerModel.dart';
import 'package:toasttab/Screens/BillerDashboard/Service/BillerController.dart';
import 'package:toasttab/Screens/BillerDashboard/Service/DashBoardContoller.dart';
import 'package:toasttab/Screens/BillerDashboard/Service/PrinterController.dart';
import 'package:toasttab/Screens/BillerDashboard/Views/Printers/PrinterSettingsDialog.dart';
import 'package:toasttab/Utils/SearchTextField.dart';

class Billdialog extends StatefulWidget {
  const Billdialog({super.key});

  @override
  State<Billdialog> createState() => _BilldialogState();
}

class _BilldialogState extends State<Billdialog> {
  final DashboardController controller = Get.find();
  final PrinterController printerCtrl = Get.find();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GetBuilder<BillerController>(
        builder: (__) {
          return Center(
            child: Container(
              width: 640.w,
              constraints: BoxConstraints(maxHeight: 460.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.r),
                color: Colors.white,
              ),
              clipBehavior: Clip.hardEdge,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── LEFT: Customer info ──────────────────────────
                  Expanded(
                    flex: 11,
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 16.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header row
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Final checkout",
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF0F172A),
                                        letterSpacing: -0.3,
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      "${__.selectedTable?.name ?? '—'}  ·  ${__.selectedTable?.seatCount ?? 0} guests",
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        color: const Color(0xFF94A3B8),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Get.back(),
                                child: Container(
                                  width: 26.w,
                                  height: 26.w,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    size: 14.sp,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          Divider(
                            height: 18.h,
                            thickness: 1,
                            color: const Color(0xFFE2E8F0),
                          ),

                          // Customer search
                          _Label("Customer name"),
                          SizedBox(height: 5.h),
                          SearchDropdownField<CustomerModel>(
                            hint: "Search customer",
                            prefixIcon: Icons.person_outline,
                            controller: __.nameController,
                            displayText: (v) => v.name ?? "No Name",
                            onSelected: (v) {
                              controller.biller.nameController.text =
                                  v.name ?? "";
                              controller.biller.phoneController.text =
                                  v.phone ?? "";
                              controller.biller.emailController.text =
                                  v.email ?? "";
                              controller.update();
                              controller.biller.update();
                            },
                            onSearch: (q) async =>
                                await controller.fetchCustomer(q),
                          ),
                          SizedBox(height: 10.h),

                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _Label("Phone"),
                                    SizedBox(height: 5.h),
                                    _Field(
                                      hint: "Phone number",
                                      icon: Icons.phone_outlined,
                                      ctrl: controller.biller.phoneController,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),

                          _Label("Email"),
                          SizedBox(height: 5.h),
                          _Field(
                            hint: "Email address",
                            icon: Icons.email_outlined,
                            ctrl: controller.biller.emailController,
                          ),
                          SizedBox(height: 12.h),

                          // Loyalty
                          GestureDetector(
                            onTap: () {
                              __.claimLoyality = !__.claimLoyality;
                              __.update();
                              __.fetchSessionDetail(__.selectedSessionId ?? "");
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 8.h,
                              ),
                              decoration: BoxDecoration(
                                color: __.claimLoyality
                                    ? const Color(0xFFF0F7FF)
                                    : const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(
                                  color: __.claimLoyality
                                      ? const Color(0xFF2F80ED).withOpacity(0.3)
                                      : const Color(0xFFE2E8F0),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    __.claimLoyality
                                        ? Icons.check_circle
                                        : Icons.circle_outlined,
                                    size: 14.sp,
                                    color: __.claimLoyality
                                        ? const Color(0xFF2F80ED)
                                        : const Color(0xFFCBD5E1),
                                  ),
                                  SizedBox(width: 8.w),
                                  Icon(
                                    Icons.stars_outlined,
                                    size: 13.sp,
                                    color: const Color(0xFFF2994A),
                                  ),
                                  SizedBox(width: 5.w),
                                  Text(
                                    "Redeem loyalty points",
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF475569),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  VerticalDivider(
                    width: 1,
                    thickness: 1,
                    color: const Color(0xFFE2E8F0),
                  ),

                  // ── RIGHT: Bill summary & actions ────────────────
                  Expanded(
                    flex: 9,
                    child: Container(
                      color: const Color(0xFFF8FAFC),
                      padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 16.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Bill summary header with printer status indicator
                          Row(
                            children: [
                              Text(
                                "Bill summary",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF64748B),
                                  letterSpacing: 0.2,
                                ),
                              ),
                              const Spacer(),
                              // Mini printer status badge
                              GetBuilder<PrinterController>(
                                builder: (p) => GestureDetector(
                                  onTap: () {
                                    Get.back();
                                    Get.dialog(
                                      const PrinterSettingsDialog(),
                                      barrierDismissible: true,
                                      barrierColor: Colors.black54,
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 6.w,
                                      vertical: 3.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: p.isConnected
                                          ? const Color(0xFFECFDF5)
                                          : const Color(0xFFF1F5F9),
                                      borderRadius: BorderRadius.circular(5.r),
                                      border: Border.all(
                                        color: p.isConnected
                                            ? const Color(
                                                0xFF10B981,
                                              ).withOpacity(0.3)
                                            : const Color(0xFFE2E8F0),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 5.w,
                                          height: 5.w,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: p.isConnected
                                                ? const Color(0xFF10B981)
                                                : const Color(0xFFCBD5E1),
                                          ),
                                        ),
                                        SizedBox(width: 4.w),
                                        Icon(
                                          Icons.print_outlined,
                                          size: 10.sp,
                                          color: p.isConnected
                                              ? const Color(0xFF10B981)
                                              : const Color(0xFF94A3B8),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),

                          // Summary rows
                          _SummaryRow(
                            "Subtotal",
                            "\$${__.billSummary?.subtotal ?? '0'}",
                          ),
                          SizedBox(height: 8.h),
                          _SummaryRow(
                            "Tax (${__.billSummary?.taxRate ?? 0}%)",
                            "\$${__.billSummary?.taxAmount ?? '0'}",
                          ),

                          if (__.billSummary?.loyalty != null ||
                              __.billSummary?.coupon != null) ...[
                            SizedBox(height: 8.h),
                            _SummaryRow(
                              "Loyalty discount",
                              "-\$${__.billSummary?.loyalityPointDiscountAmount ?? '0'}",
                              isDiscount: true,
                            ),
                          ],

                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            child: Divider(
                              height: 1,
                              thickness: 1,
                              color: const Color(0xFFE2E8F0),
                            ),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Grand total",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                              Text(
                                "\$${__.billSummary?.totalAmount ?? '0.00'}",
                                style: TextStyle(
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF2F80ED),
                                  height: 1.0,
                                ),
                              ),
                            ],
                          ),

                          const Spacer(),

                          // ── Print Bill button ─────────────────────
                          GetBuilder<PrinterController>(
                            builder: (p) => _ActionBtn(
                              label: p.isPrinting
                                  ? "Printing..."
                                  : p.mockMode
                                  ? "Preview receipt"
                                  : p.isConnected
                                  ? "Print bill"
                                  : "Print bill (no printer)",
                              icon: p.isPrinting
                                  ? Icons.hourglass_top_rounded
                                  : p.mockMode
                                  ? Icons.receipt_long_outlined
                                  : Icons.print_outlined,
                              bg: p.mockMode
                                  ? const Color(0xFFFFF4EC)
                                  : p.isConnected
                                  ? const Color(0xFFF1F5F9)
                                  : const Color(0xFFFEF2F2),
                              fg: p.mockMode
                                  ? const Color(0xFFF2994A)
                                  : p.isConnected
                                  ? const Color(0xFF475569)
                                  : const Color(0xFFEF4444),
                              onTap: p.isPrinting
                                  ? () {}
                                  : () {
                                      if (!p.canPrint) {
                                        // Open printer settings if not connected and not mock
                                        Get.back();
                                        Get.dialog(
                                          const PrinterSettingsDialog(),
                                          barrierDismissible: true,
                                          barrierColor: Colors.black54,
                                        );
                                        return;
                                      }
                                      if (__.billSummary != null) {
                                        p.printBill(
                                          context: context,
                                          bill: __.billSummary!,
                                          tableName:
                                              __.selectedTable?.name ?? "Table",
                                          restaurantName: "Agnes Bill",
                                          restaurantAddress:
                                              "123 Main Street, City",
                                          restaurantPhone: "+1 234 567 8900",
                                        );
                                      }
                                    },
                            ),
                          ),

                          SizedBox(height: 8.h),

                          // ── Mark as paid ──────────────────────────
                          _ActionBtn(
                            label: "Mark as paid & close",
                            icon: Icons.check_circle_outline,
                            bg: const Color(0xFF2F80ED),
                            fg: Colors.white,
                            onTap: () {
                              controller.biller.checkoutBill(
                                __.selectedSessionId!,
                              );
                              Get.back();
                            },
                          ),
                          SizedBox(height: 8.h),
                          Center(
                            child: GestureDetector(
                              onTap: () => Get.back(),
                              child: Text(
                                "Cancel & return",
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: const Color(0xFF94A3B8),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── Helpers (unchanged from original) ─────────────────────────────────────────
class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      fontSize: 10.sp,
      fontWeight: FontWeight.w600,
      color: const Color(0xFF94A3B8),
      letterSpacing: 0.3,
    ),
  );
}

class _Field extends StatelessWidget {
  final String hint;
  final IconData icon;
  final TextEditingController? ctrl;
  const _Field({required this.hint, required this.icon, this.ctrl});

  @override
  Widget build(BuildContext context) => Container(
    height: 36.h,
    decoration: BoxDecoration(
      color: const Color(0xFFF1F5F9),
      borderRadius: BorderRadius.circular(7.r),
    ),
    child: TextField(
      controller: ctrl,
      style: TextStyle(fontSize: 12.sp, color: const Color(0xFF0F172A)),
      textAlignVertical: TextAlignVertical.center,
      
      decoration: InputDecoration(
        hintText: hint,
        isDense: true,

        hintStyle: TextStyle(fontSize: 11.sp, color: const Color(0xFFCBD5E1)),
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 9.h),
        prefixIcon: Icon(icon, size: 14.sp, color: const Color(0xFFCBD5E1)),
        prefixIconConstraints: BoxConstraints(minWidth: 32.w, minHeight: 36.h),
      ),
    ),
  );
}

class _SummaryRow extends StatelessWidget {
  final String label, value;
  final bool isDiscount;
  const _SummaryRow(this.label, this.value, {this.isDiscount = false});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: TextStyle(
          fontSize: 12.sp,
          color: const Color(0xFF64748B),
          fontWeight: FontWeight.w500,
        ),
      ),
      Text(
        value,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: isDiscount ? const Color(0xFF10B981) : const Color(0xFF0F172A),
        ),
      ),
    ],
  );
}

class _ActionBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color bg, fg;
  final VoidCallback onTap;
  const _ActionBtn({
    required this.label,
    required this.icon,
    required this.bg,
    required this.fg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      height: 38.h,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: fg, size: 14.sp),
          SizedBox(width: 8.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: fg,
            ),
          ),
        ],
      ),
    ),
  );
}
