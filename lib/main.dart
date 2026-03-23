import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toasttab/Screens/AuthenticationScreen/AuthenticationScreen.dart';
import 'package:toasttab/Screens/BillerDashboard/BillerDashboardScreen.dart';
import 'package:toasttab/Screens/Kitchen/KitchenScreen.dart';

final String baseUrl = "https://api.pos.palqar.cloud/api/v1";
String authToken = "";
String restaurantId = "";
String role = "";
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    final pref = await SharedPreferences.getInstance();
    authToken = pref.getString("accessToken") ?? "";
    role = pref.getString("role") ?? "";
    restaurantId = pref.getString("restaurantId") ?? "";
  } catch (e) {
    authToken = "";
    role = "";
    restaurantId = "";
    debugPrint("SharedPreferences init failed: $e");
  }
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(1280, 832),

      child: GetMaterialApp(
        theme: ThemeData(
          fontFamily: "Inter",
          scaffoldBackgroundColor: Color(0xFFF8FAFC),
        ),
        home: (authToken == "")
            ? AuthenticationScreen()
            : (role == "CHEF")
            ? KitchenScreen()
            : BillerdashBoardScreen(),
      ),
    );
  }
}
