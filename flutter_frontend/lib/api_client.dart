import 'dart:convert';
import 'dart:developer';
import 'package:flutter_frontend/api_endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class ApiClient {
  static Future sendRequest(String path,
      {Function methodFun = http.get,
      Map<String, dynamic>? body,
      bool authorizedRequest = false}) async {
    try {
      http.Response response;
      final url = Uri.parse(path);
      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      };

      if (authorizedRequest) {
        final jwt = await getUserToken();
        if (jwt == null) {
          return Future.error("Session expired, try logging in again");
        }
        headers['Authorization'] = 'Bearer $jwt';
      }

      if (body != null) {
        response =
            await methodFun(url, headers: headers, body: jsonEncode(body));
      } else {
        response = await methodFun(url, headers: headers);
      }

      final result = jsonDecode(response.body);

      if (response.statusCode >= 400) {
        return Future.error(result.containsKey('message')
            ? result['message']
            : result['detail']);
      }

      return result;
    } catch (e) {
      log('Error: $e');
      return Future.error('Something went wrong');
    }
  }

  static Future login(String jwt, String refreshToken) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: 'jwt', value: jwt);
    await storage.write(key: 'jwtRefresh', value: refreshToken);
  }

  static void logout() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'jwt');
    await storage.delete(key: 'jwtRefresh');
  }

  static Future<String?> getUserToken() async {
    const storage = FlutterSecureStorage();
    final jwt = await storage.read(key: 'jwt');
    final refreshToken = await storage.read(key: 'jwtRefresh');

    if (jwt != null && !JwtDecoder.isExpired(jwt)) {
      return jwt;
    }

    if (refreshToken != null) {
      return await _tryRefreshToken(refreshToken);
    }

    return null;
  }

  static Future<String?> _tryRefreshToken(String refreshToken) async {
    return sendRequest(ApiEndpoints.refreshEndpoint,
        methodFun: http.post,
        body: {
          'refresh_token': refreshToken,
        }).then((data) async {
      await login(data['token'], data['refresh_token']);
      return data['token'] as String?;
    }).catchError((e) {
      return null;
    });
  }
}
