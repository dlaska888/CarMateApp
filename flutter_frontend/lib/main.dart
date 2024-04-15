import 'package:flutter/material.dart';
import 'package:flutter_frontend/catemateapp_theme.dart';
import 'package:flutter_frontend/screens/dashboard.dart';
import 'package:flutter_frontend/screens/index.dart';
import 'package:flutter_frontend/screens/login.dart';
import 'package:flutter_frontend/screens/register.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      home: const Index(),
      routes: {
        '/login': (context) => const Login(),
        '/register': (context) => const Register(),
        '/dashboard': (context) => const Dashboard(),
      },
    );
  }
}
