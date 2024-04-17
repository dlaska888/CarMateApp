import 'package:flutter/material.dart';
import 'package:flutter_frontend/catemateapp_theme.dart';
import 'package:flutter_frontend/router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(theme: lightTheme, routerConfig: getRouter());
  }
}
