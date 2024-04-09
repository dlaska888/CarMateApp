import 'package:flutter/material.dart';
import 'package:flutter_frontend/screens/dashboard_pages/home/home_desktop.dart';
import 'package:flutter_frontend/screens/dashboard_pages/home/home_mobile.dart';

class HomeResponsivePage extends StatelessWidget {
  const HomeResponsivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 768) {
        return const HomePageMobile();
      } else {
        return const HomePageDesktop();
      }
    });
  }
}
