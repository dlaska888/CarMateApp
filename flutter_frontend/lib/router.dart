import 'package:flutter_frontend/helpers/api_client.dart';
import 'package:flutter_frontend/screens/dashboard.dart';
import 'package:flutter_frontend/screens/index.dart';
import 'package:flutter_frontend/screens/login.dart';
import 'package:flutter_frontend/screens/register.dart';
import 'package:go_router/go_router.dart';

GoRouter getRouter() {
  return GoRouter(
      initialLocation: '/',
      redirect: (context, state) async {
        if (state.matchedLocation == '/dashboard' &&
            await ApiClient.getUserToken() == null) {
          return '/login';
        }

        if (state.matchedLocation == '/login' &&
            await ApiClient.getUserToken() != null) {
          return '/dashboard';
        }

        return state.matchedLocation;
      },
      routes: [
        GoRoute(path: '/', builder: (context, state) => const Index()),
        GoRoute(path: '/login', builder: (context, state) => const Login()),
        GoRoute(
            path: '/register', builder: (context, state) => const Register()),
        GoRoute(
            path: '/dashboard', builder: (context, state) => const Dashboard()),
      ]);
}
