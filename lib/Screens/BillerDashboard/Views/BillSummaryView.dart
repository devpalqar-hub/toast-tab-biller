import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:toasttab/Screens/BillerDashboard/Models/Response/MenuModel.dart';
import 'package:toasttab/Screens/BillerDashboard/Models/Response/TableModel.dart';
import 'package:toasttab/Screens/BillerDashboard/Service/DashBoardContoller.dart';
import 'package:toasttab/Screens/BillerDashboard/Views/BillDialog.dart';
import 'package:toasttab/Screens/BillerDashboard/Views/BillSummaryCards/SessionSwitchView.dart';
import 'package:toasttab/Screens/BillerDashboard/Views/CancelDialog.dart';

class BillSummaryView extends StatelessWidget {
  BillSummaryView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (controller) {
        if (controller.biller.selectedTable == null)
          return const SizedBox.shrink();

        final TableData table = controller.biller.selectedTable!;
        final bool hasOrdered =
            controller.biller.billSummary?.items?.isNotEmpty == true;

        return FadeInRight(
          duration: const Duration(milliseconds: 200),
          child: Container(
            width: 300.w,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ─────────────────────────────────────
                Container(
                  padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 10.h),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // ── Table avatar ──────────────────────────────
                      Container(
                        width: 34.w,
                        height: 34.w,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2F80ED),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          controller.biller.getTableName(table.name),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(width: 9.w),

                      // ── Table name + session switcher ─────────────
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              table.name,
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF0F172A),
                                letterSpacing: -0.2,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            SessionSwitchView(),
                          ],
                        ),
                      ),

                      SizedBox(width: 6.w),

                      // ── Action buttons stacked vertically ─────────
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // New bill button
                          GestureDetector(
                            onTap: () {
                              controller.biller.selectedSession = null;
                              controller.biller.selectedSessionId = null;
                              controller.biller.totalAmount = "0";
                              controller.biller.taxAmount = "0";
                              controller.biller.subTotalAmount = "0";
                              controller.biller.billSummary = null;
                              controller.biller.nameController.clear();
                              controller.biller.phoneController.clear();
                              controller.biller.emailController.clear();
                              controller.biller.update();
                              controller.update();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0F7FF),
                                borderRadius: BorderRadius.circular(5.r),
                                border: Border.all(
                                  color: const Color(
                                    0xFF2F80ED,
                                  ).withOpacity(0.25),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.add,
                                    size: 11.sp,
                                    color: const Color(0xFF2F80ED),
                                  ),
                                  SizedBox(width: 3.w),
                                  Text(
                                    "New",
                                    style: TextStyle(
                                      color: const Color(0xFF2F80ED),
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Cancel session button — only when session is active
                          if (controller.biller.selectedSessionId != null &&
                              controller
                                  .biller
                                  .selectedSessionId!
                                  .isNotEmpty) ...[
                            SizedBox(height: 4.h),
                            GestureDetector(
                              onTap: () => CancelSessionDialog.show(
                                context,
                                sessionNumber:
                                    controller
                                        .biller
                                        .selectedSession
                                        ?.sessionNumber ??
                                    "",
                                onConfirm: () =>
                                    controller.biller.cancelSession(
                                      controller.biller.selectedSessionId!,
                                    ),
                              ),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFEF2F2),
                                  borderRadius: BorderRadius.circular(5.r),
                                  border: Border.all(
                                    color: const Color(
                                      0xFFEF4444,
                                    ).withOpacity(0.25),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.cancel_outlined,
                                      size: 11.sp,
                                      color: const Color(0xFFEF4444),
                                    ),
                                    SizedBox(width: 3.w),
                                    Text(
                                      "Cancel",
                                      style: TextStyle(
                                        color: const Color(0xFFEF4444),
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                // ── Send to Kitchen ─────────────────────────────
                if (controller.biller.newBatchItems.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                    child: _KitchenBtn(
                      onTap: () {
                        if (controller.biller.newBatchItems.isNotEmpty) {
                          if (controller.biller.selectedSessionId == null ||
                              controller.biller.selectedSessionId == "") {
                            controller.biller.startSession(
                              tableID: controller.biller.selectedTable!.id!,
                              guestCount:
                                  controller.biller.selectedTable!.seatCount,
                            );
                          } else {
                            controller.biller.startBatch();
                          }
                        } else {}
                      },
                    ),
                  ),

                if (controller.biller.newBatchItems.isNotEmpty)
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: const Color(0xFFE2E8F0),
                  ),

                // ── Scrollable middle area ──────────────────────
                // Uses LayoutBuilder to measure available space between
                // the header/kitchen-btn area and the totals/checkout footer.
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final double totalH = constraints.maxHeight;

                      return hasOrdered
                          // ── Two sections: new order (max 3/4) + ordered ──
                          ? Column(
                              children: [
                                // New order — capped at 3/4 of available height
                                if (controller
                                    .biller
                                    .newBatchItems
                                    .isNotEmpty) ...[
                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxHeight: totalH * 0.75,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(
                                            12.w,
                                            8.h,
                                            12.w,
                                            4.h,
                                          ),
                                          child: _SectionLabel(
                                            label: "New order",
                                            count: controller
                                                .biller
                                                .newBatchItems
                                                .length,
                                            color: const Color(0xFFF2994A),
                                          ),
                                        ),
                                        Flexible(
                                          child: ListView(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8.w,
                                            ),
                                            shrinkWrap: true,
                                            children: controller
                                                .biller
                                                .newBatchItems
                                                .map((item) {
                                                  final MenuModel menu =
                                                      controller
                                                          .batchItemtoMenuItem(
                                                            item,
                                                          );
                                                  final double linePrice =
                                                      (double.tryParse(
                                                            menu.effectivePrice ??
                                                                "0",
                                                          ) ??
                                                          0) *
                                                      (item.quantity ?? 1);
                                                  return _ItemRow(
                                                    qty: item.quantity ?? 1,
                                                    title: menu.name ?? "",
                                                    price: linePrice,
                                                    isPending: true,

                                                    onAdd: () => controller
                                                        .biller
                                                        .addToBatch(menu),
                                                    onRemove: () => controller
                                                        .biller
                                                        .removeFromBatch(menu),
                                                  );
                                                })
                                                .toList(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Divider(
                                    height: 1,
                                    thickness: 1,
                                    color: const Color(0xFFE2E8F0),
                                  ),
                                ],
                                // Ordered items — takes remaining space
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(
                                          12.w,
                                          8.h,
                                          12.w,
                                          4.h,
                                        ),
                                        child: _SectionLabel(
                                          label: "Ordered",
                                          count: controller
                                              .biller
                                              .billSummary!
                                              .items!
                                              .length,
                                          color: const Color(0xFF10B981),
                                        ),
                                      ),
                                      Expanded(
                                        child: ListView(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8.w,
                                          ),
                                          children: controller
                                              .biller
                                              .billSummary!
                                              .items!
                                              .map((item) {
                                                final MenuModel menu =
                                                    controller.menuFromId(
                                                      item.menuItem!.id!,
                                                    );
                                                final double linePrice =
                                                    (double.tryParse(
                                                          menu.effectivePrice ??
                                                              "0",
                                                        ) ??
                                                        0) *
                                                    (item.quantity ?? 1);
                                                return _ItemRow(
                                                  qty: item.quantity ?? 1,
                                                  title: menu.name ?? "",
                                                  price: double.parse(
                                                    item.totalPrice ?? "0",
                                                  ),
                                                  status: item.status,
                                                  isPending: false,
                                                  onCancelItem: () {
                                                    CancelItemDialog.show(
                                                      context,
                                                      itemName: item.name ?? "",
                                                      onConfirm: (reason) {
                                                        controller.biller
                                                            .cancelBatchItem(
                                                              sessionId:
                                                                  controller
                                                                      .biller
                                                                      .selectedSessionId ??
                                                                  "",
                                                              batchId:
                                                                  item.batchId ??
                                                                  "",
                                                              itemId:
                                                                  item.id ?? "",
                                                              cancelReason:
                                                                  reason,
                                                            );
                                                      },
                                                    );
                                                  },
                                                );
                                              })
                                              .toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          // ── No ordered items: new order fills everything ──
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                    12.w,
                                    8.h,
                                    12.w,
                                    4.h,
                                  ),
                                  child: _SectionLabel(
                                    label: "New order",
                                    count:
                                        controller.biller.newBatchItems.length,
                                    color: const Color(0xFFF2994A),
                                  ),
                                ),
                                Expanded(
                                  child: ListView(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                    ),
                                    children: controller.biller.newBatchItems
                                        .map((item) {
                                          final MenuModel menu = controller
                                              .batchItemtoMenuItem(item);
                                          final double linePrice =
                                              (double.tryParse(
                                                    menu.effectivePrice ?? "0",
                                                  ) ??
                                                  0) *
                                              (item.quantity ?? 1);
                                          return _ItemRow(
                                            qty: item.quantity ?? 1,
                                            title: menu.name ?? "",
                                            price: linePrice,
                                            isPending: true,
                                            onAdd: () => controller.biller
                                                .addToBatch(menu),
                                            onRemove: () => controller.biller
                                                .removeFromBatch(menu),
                                          );
                                        })
                                        .toList(),
                                  ),
                                ),
                              ],
                            );
                    },
                  ),
                ),

                // ── Bill Totals ─────────────────────────────────
                Container(
                  padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 10.h),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Color(0xFFE2E8F0), width: 1),
                    ),
                  ),
                  child: Column(
                    children: [
                      _TotalRow(
                        label: "Subtotal",
                        value: "\$${controller.biller.subTotalAmount}",
                      ),
                      SizedBox(height: 4.h),
                      _TotalRow(
                        label: "Tax & service",
                        value: "\$${controller.biller.taxAmount}",
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: Divider(
                          height: 1,
                          thickness: 1,
                          color: const Color(0xFFE2E8F0),
                        ),
                      ),
                      _TotalRow(
                        label: "Total",
                        value: "\$${controller.biller.totalAmount}",
                        bold: true,
                      ),
                    ],
                  ),
                ),

                // ── Checkout Button ─────────────────────────────
                Padding(
                  padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 12.h),
                  child: GestureDetector(
                    onTap: () {
                      if (controller.biller.billSummary != null)
                        Get.dialog(
                          Material(
                            color: Colors.transparent,
                            child: Center(
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth: 600.w,
                                  maxHeight: 500.h,
                                ),
                                margin: const EdgeInsets.all(24),
                                child: Billdialog(),
                              ),
                            ),
                          ),
                          barrierDismissible: true,
                          barrierColor: Colors.black54,
                        );
                    },
                    child: Container(
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2F80ED),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 14.sp,
                            color: Colors.white,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            "Final checkout",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 13.sp,
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
        );
      },
    );
  }
}

// ── All helper widgets unchanged ──────────────────────────────────────────────
class _KitchenBtn extends StatelessWidget {
  final VoidCallback onTap;
  const _KitchenBtn({required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 32.h,
        decoration: BoxDecoration(
          color: const Color(0xFFFFF4EC),
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(color: const Color(0xFFF2994A).withOpacity(0.4)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.outdoor_grill_outlined,
              size: 13.sp,
              color: const Color(0xFFF2994A),
            ),
            SizedBox(width: 5.w),
            Text(
              "Send to kitchen",
              style: TextStyle(
                color: const Color(0xFFF2994A),
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  const _SectionLabel({
    required this.label,
    required this.count,
    required this.color,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF64748B),
            letterSpacing: 0.2,
          ),
        ),
        SizedBox(width: 6.w),
        if (count > 0)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Text(
              "$count",
              style: TextStyle(
                fontSize: 9.sp,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
      ],
    );
  }
}

class _ItemRow extends StatelessWidget {
  final int qty;
  final String title;
  final double price;
  final bool isPending;
  final String? status;
  final VoidCallback? onAdd;
  final VoidCallback? onRemove;
  final VoidCallback? onCancelItem; // NEW

  const _ItemRow({
    required this.qty,
    required this.title,
    required this.price,
    required this.isPending,
    this.status,
    this.onAdd,
    this.onRemove,
    this.onCancelItem, // NEW
  });

  @override
  Widget build(BuildContext context) {
    final bool isCancelled = status == 'CANCELLED';

    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 4.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFE2E8F0).withOpacity(0.6),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          // Qty control / badge
          if (isPending)
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(5.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _QtyBtn(icon: Icons.remove, onTap: onRemove),
                  SizedBox(
                    width: 18.w,
                    child: Text(
                      "$qty",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  _QtyBtn(icon: Icons.add, onTap: onAdd),
                ],
              ),
            )
          else
            Container(
              width: 18.w,
              height: 18.w,
              decoration: BoxDecoration(
                color: isCancelled
                    ? const Color(0xFFFEF2F2)
                    : const Color(0xFF10B981).withOpacity(0.12),
                borderRadius: BorderRadius.circular(4.r),
              ),
              alignment: Alignment.center,
              child: Text(
                "$qty",
                style: TextStyle(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w700,
                  color: isCancelled
                      ? const Color(0xFFEF4444)
                      : const Color(0xFF10B981),
                ),
              ),
            ),

          SizedBox(width: 8.w),

          // Title
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: isCancelled
                    ? const Color(0xFFCBD5E1)
                    : const Color(0xFF0F172A),
                decoration: isCancelled ? TextDecoration.lineThrough : null,
              ),
            ),
          ),

          SizedBox(width: 4.w),

          // Price
          Text(
            "\$${price.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: isCancelled
                  ? const Color(0xFFCBD5E1)
                  : const Color(0xFF0F172A),
            ),
          ),

          // Cancel button — only for PENDING ordered items
          if (onCancelItem != null) ...[
            SizedBox(width: 6.w),
            GestureDetector(
              onTap: onCancelItem,
              child: Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Icon(
                  Icons.close,
                  size: 11.sp,
                  color: const Color(0xFFEF4444),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _QtyBtn({required this.icon, this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
      child: Icon(icon, size: 10.sp, color: const Color(0xFF2F80ED)),
    ),
  );
}

class _TotalRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  const _TotalRow({
    required this.label,
    required this.value,
    this.bold = false,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: bold ? 13.sp : 11.sp,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
            color: bold ? const Color(0xFF0F172A) : const Color(0xFF64748B),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: bold ? 15.sp : 11.sp,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
            color: bold ? const Color(0xFF2F80ED) : const Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }
}
