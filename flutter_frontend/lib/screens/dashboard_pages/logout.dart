import 'package:flutter/material.dart';
import 'package:flutter_frontend/api_client.dart';
import 'package:go_router/go_router.dart';

class LogoutPage extends StatelessWidget {
  const LogoutPage({super.key});
  @override
  Widget build(BuildContext context) {
    ApiClient.logout();
    context.go('/login');
    return const SizedBox();
  }
}
