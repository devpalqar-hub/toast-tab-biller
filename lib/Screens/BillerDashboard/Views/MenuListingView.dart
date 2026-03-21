import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:toasttab/Screens/BillerDashboard/Service/DashBoardContoller.dart';
import 'package:toasttab/Screens/BillerDashboard/Views/MenuCards/MenuRestockDialog.dart';

class MenuListingView extends StatelessWidget {
  const MenuListingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: GetBuilder<DashboardController>(
        builder: (controller) {
          final visibleMenus = controller.menus
              .where(
                (m) =>
                    controller.selectedCategory?.id == "0" ||
                    controller.selectedCategory?.id == m.categoryId,
              )
              .toList();

          return Column(
            children: [
              // ── Category chips ──────────────────────────
              Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                child: SizedBox(
                  height: 26.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.categories.length,
                    itemBuilder: (_, i) {
                      final cat = controller.categories[i];
                      final sel = controller.selectedCategory == cat;
                      return GestureDetector(
                        onTap: () {
                          controller.selectedCategory = cat;
                          controller.update();
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 130),
                          margin: EdgeInsets.only(right: 5.w),
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          decoration: BoxDecoration(
                            color: sel
                                ? const Color(0xFF2F80ED)
                                : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            cat.name ?? "--",
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              color: sel
                                  ? Colors.white
                                  : const Color(0xFF64748B),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Divider(height: 1, thickness: 1, color: const Color(0xFFE2E8F0)),

              // ── Grid ────────────────────────────────────
              Expanded(
                child: visibleMenus.isEmpty
                    ? Center(
                        child: Text(
                          "No items",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                      )
                    : GridView.builder(
                        padding: EdgeInsets.all(8.w),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          crossAxisSpacing: 6.w,
                          mainAxisSpacing: 6.h,
                          childAspectRatio: 16 / 12,
                        ),
                        itemCount: visibleMenus.length,
                        itemBuilder: (_, i) {
                          final m = visibleMenus[i];
                          return _MenuCard(
                            imageUrl: m.imageUrl ?? "",
                            title: m.name ?? "",
                            price:
                                double.tryParse(m.effectivePrice.toString()) ??
                                0,
                            originalPrice:
                                double.tryParse(m.price.toString()) ?? 0,
                            onTap: () => controller.biller.addToBatch(m),
                            onToggleStock: () {
                              if (!(m.isOutOfStock ?? false)) {
                                m.isOutOfStock = !m.isOutOfStock!;
                                controller.changeMenuStatus(m);
                              } else {
                                if (m.itemType == "STOCKABLE") {
                                  Get.dialog(
                                    RestockDialog(
                                      itemName: m.name ?? "",
                                      currentStock: 0,
                                      onConfirm: (c) {
                                        m.isOutOfStock = !m.isOutOfStock!;
                                        controller.changeMenuStatus(
                                          m,
                                          stockStatus: true,
                                          count: c,
                                        );
                                      },
                                    ),
                                  );
                                } else {
                                  m.isOutOfStock = !m.isOutOfStock!;
                                  controller.changeMenuStatus(
                                    m,
                                    stockStatus: true,
                                  );
                                }
                              }
                              controller.update();
                            },
                            inStock: !m.isOutOfStock!,
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ── Card ──────────────────────────────────────────────────────────────────────
class _MenuCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final double price;
  final double originalPrice;
  final bool inStock; // ← new
  final VoidCallback onTap;
  final VoidCallback onToggleStock; // ← new

  const _MenuCard({
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.originalPrice,
    required this.inStock,
    required this.onTap,
    required this.onToggleStock,
  });

  bool get _hasDiscount => originalPrice > 0 && originalPrice != price;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: inStock ? onTap : null,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(
            // Red border hint when out of stock
            color: inStock
                ? const Color(0xFFE2E8F0)
                : const Color(0xFFEF4444).withOpacity(0.35),
            width: 1,
          ),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image ──────────────────────────────
            Expanded(
              flex: 11,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Slight desaturation overlay when out of stock
                  ColorFiltered(
                    colorFilter: inStock
                        ? const ColorFilter.mode(
                            Colors.transparent,
                            BlendMode.saturation,
                          )
                        : ColorFilter.mode(
                            Colors.grey.withOpacity(0.55),
                            BlendMode.saturation,
                          ),
                    child: imageUrl.isNotEmpty
                        ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            loadingBuilder: (_, child, p) =>
                                p == null ? child : _placeholder(),
                            errorBuilder: (_, __, ___) => _placeholder(),
                          )
                        : _placeholder(),
                  ),

                  // Discount chip (only when in stock)
                  if (_hasDiscount && inStock)
                    Positioned(
                      top: 3,
                      left: 3,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 3.w,
                          vertical: 1.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444),
                          borderRadius: BorderRadius.circular(3.r),
                        ),
                        child: Text(
                          "-${(((originalPrice - price) / originalPrice) * 100).round()}%",
                          style: TextStyle(
                            fontSize: 7.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                  // ── LEFT: stock toggle button ───────────────
                  Positioned(
                    bottom: 3,
                    left: 3,
                    child: GestureDetector(
                      onTap: onToggleStock,
                      child: Container(
                        width: 15.w,
                        height: 15.w,
                        decoration: BoxDecoration(
                          color: inStock
                              ? const Color(0xFF10B981) // green = in stock
                              : const Color(0xFFEF4444), // red = out of stock
                          borderRadius: BorderRadius.circular(3.r),
                        ),
                        child: Icon(
                          Icons.change_circle,
                          size: 10.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  // ── RIGHT: add to order button ──────────────
                  Positioned(
                    bottom: 3,
                    right: 3,
                    child: GestureDetector(
                      onTap: inStock ? onTap : null,
                      child: Container(
                        width: 15.w,
                        height: 15.w,
                        decoration: BoxDecoration(
                          color: inStock
                              ? const Color(0xFF2F80ED)
                              : const Color(0xFFCBD5E1),
                          borderRadius: BorderRadius.circular(3.r),
                        ),
                        child: Icon(
                          Icons.add,
                          size: 10.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Info ───────────────────────────────
            Expanded(
              flex: 7,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w600,
                        color: inStock
                            ? const Color(0xFF0F172A)
                            : const Color(0xFF94A3B8),
                        height: 1.2,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        if (!inStock)
                          Text(
                            "Out of stock",
                            style: TextStyle(
                              fontSize: 8.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFEF4444),
                            ),
                          )
                        else ...[
                          Text(
                            "\$${price.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF2F80ED),
                            ),
                          ),
                          if (_hasDiscount) ...[
                            SizedBox(width: 2.w),
                            Text(
                              "\$${originalPrice.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 7.sp,
                                color: const Color(0xFFCBD5E1),
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() => Container(
    color: const Color(0xFFF1F5F9),
    child: const Center(
      child: Icon(Icons.fastfood_outlined, size: 20, color: Color(0xFFCBD5E1)),
    ),
  );
}
