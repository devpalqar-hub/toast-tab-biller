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
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences pref = await SharedPreferences.getInstance();
  // authToken = pref.getString("accessToken") ?? "";
  restaurantId = pref.getString("restaurantId") ?? "";
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
        home: (authToken == "") ? AuthenticationScreen() : KitchenScreen(),
      ),
    );
  }
}
