import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:toasttab/Screens/AuthenticationScreen/AuthenticationScreen.dart';
import 'package:toasttab/Screens/BillerDashboard/BillerDashboardScreen.dart';

final String baseUrl = "https://api.pos.palqar.cloud/api/v1";
void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
       designSize:  Size(1280, 832), 
       child: GetMaterialApp(home: BillerdashBoardScreen()));
  }
}
