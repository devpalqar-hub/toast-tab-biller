import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BillSummaryView extends StatelessWidget {
  const BillSummaryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 370.w,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER
              Row(
                children: [
                  Container(
                    height: 50.w,
                    width: 50.w,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF2F80ED),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "T3",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Table 03",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Text(
                              "Session 1",
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2F80ED),
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              "• Active",
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        )
                      ],
                      
                    ),
                    
                  ),
                ],
              ),
                 _divider(),
              SizedBox(height: 20.h),

              /// ITEMS
              _itemRow(
                qty: "2x",
                title: "Margherita Pizza",
                price: "\$29.00",
                status: "PREPARING",
                statusColor: Color(0xFFFFE7C2),
                statusTextColor: Color(0xFFF2994A),
                rating: 0,
              ),

              _divider(),

              _itemRow(
                qty: "1x",
                title: "Truffle Fries",
                price: "\$8.90",
                status: "READY",
                statusColor: Color(0xFFE6F4EA),
                statusTextColor: Color(0xFF27AE60),
                rating: 4,
              ),

              _divider(),

              _itemRow(
                qty: "1x",
                title: "Garden Salad",
                price: "\$11.20",
                status: "SERVED",
                statusColor: Color(0xFFE9EEF5),
                statusTextColor: Colors.grey,
                rating: 5,
                disabled: true,
              ),

              SizedBox(height: 150.h),
                _divider(),
              /// BILL SUMMARY
              _rowText("Subtotal", "\$61.10"),
              SizedBox(height: 6.h),
              _rowText("Service & Tax", "\$6.11"),
              Divider(height: 20.h),

              _rowText(
                "Session Total",
                "\$67.21",
                bold: true,
                blue: true,
              ),

              SizedBox(height: 20.h),

              /// BUTTONS
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.r),
                        border: Border.all(color: Color(0xFF2F80ED)),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "Split Bill",
                        style: TextStyle(
                          color: Color(0xFF2F80ED),
                          fontWeight: FontWeight.w600,
                          fontSize: 15.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Container(
                      height: 48.h,
                      decoration: BoxDecoration(
                        color: Color(0xFF2F80ED),
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "Final Checkout",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 15.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      child: Divider(
        thickness: 1,
        color: Color(0xFFE0E6ED),
      ),
    );
  }

  Widget _itemRow({
    required String qty,
    required String title,
    required String price,
    required String status,
    required Color statusColor,
    required Color statusTextColor,
    required int rating,
    bool disabled = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
          decoration: BoxDecoration(
            color: Color(0xFFE9EEF5),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            qty,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13.sp,
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: disabled ? Colors.grey : Colors.black,
                ),
              ),
              SizedBox(height: 6.h),
              Row(
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color: statusTextColor,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Row(
                    children: List.generate(
                      5,
                      (index) => Icon(
                        index < rating
                            ? Icons.star
                            : Icons.star_border,
                        size: 14.sp,
                        color: Colors.amber,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        Text(
          price,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: disabled ? Colors.grey : Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _rowText(String left, String right,
      {bool bold = false, bool blue = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          left,
          style: TextStyle(
            fontSize: bold ? 17.sp : 14.sp,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        Text(
          right,
          style: TextStyle(
            fontSize: bold ? 18.sp : 14.sp,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
            color: blue ? Color(0xFF2F80ED) : Colors.black,
          ),
        ),
      ],
    );
  }
}