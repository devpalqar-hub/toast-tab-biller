import 'package:flutter/material.dart';
import 'package:toasttab/Screens/BillerDashboard/Views/BillSummaryView.dart';
import 'package:toasttab/Screens/BillerDashboard/Views/MenuListingView.dart';
import 'package:toasttab/Screens/BillerDashboard/Views/TableStatusView.dart';

class BillerdashBoardScreen extends StatelessWidget {
  const BillerdashBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  TableStatusView(),
                  Expanded(child: MenuListingView()),
                  BillSummaryView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
