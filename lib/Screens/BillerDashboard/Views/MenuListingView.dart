import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MenuListingView extends StatelessWidget {
  const MenuListingView({super.key});

  final List<Map<String, dynamic>> categories = const [
    {"title": "All Items"},
    {"title": "Starters"},
    {"title": "Main Course"},
    {"title": "Pizza & Pasta"},
    {"title": "Seafood"},
  ];

  final List<Map<String, dynamic>> items = const [
    {
      "image":
          "https://www.cookingclassy.com/wp-content/uploads/2022/03/biryani-13.jpg",
      "title": "Western Biriyani",
      "description": "half",
      "price": 180.0,
      "originalPrice": 180.0,
    },
    {
      "image":
          "https://www.cookingclassy.com/wp-content/uploads/2022/03/biryani-13.jpg",
      "title": "Western Biriyani",
      "description": "half",
      "price": 180.0,
      "originalPrice": 180.0,
    },
    {
      "image":
          "https://www.cookingclassy.com/wp-content/uploads/2022/03/biryani-13.jpg",
      "title": "Western Biriyani",
      "description": "half",
      "price": 180.0,
      "originalPrice": 180.0,
    },
    {
      "image":
          "https://www.cookingclassy.com/wp-content/uploads/2022/03/biryani-13.jpg",
      "title": "Western Biriyani",
      "description": "half",
      "price": 180.0,
      "originalPrice": 180.0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF6F7F8),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 38.h,

              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(right: 8.w),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: index == 0 ? Colors.blue : Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Center(
                      child: Text(
                        categories[index]['title'],
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: index == 0 ? Colors.white : Colors.black,
                          fontWeight: index == 0
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 16.h),
            Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey.shade300,
            ),
            SizedBox(height: 16.h),

            SizedBox(
              height: 160.h, // adjust height according to your card
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return SizedBox(
                    child: FoodItemCard(
                      imageUrl: item['image'],
                      title: item['title'],
                      description: item['description'],
                      price: item['price'],
                      originalPrice: item['originalPrice'],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FoodItemCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final double price;
  final double originalPrice;

  const FoodItemCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.price,
    required this.originalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 127.w,
      height: 155.h,
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            child: Image.network(
              imageUrl,
              width: 127.w,
              height: 97.h,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return SizedBox(
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 97.h,
                  width: 127.w,
                  color: Colors.grey.shade200,
                  child: const Icon(
                    Icons.fastfood,
                    size: 30,
                    color: Colors.grey,
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: EdgeInsets.all(8.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 6.h),
                // Price Row
                Row(
                  children: [
                    Text(
                      price.toStringAsFixed(2),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      originalPrice.toStringAsFixed(2),
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
