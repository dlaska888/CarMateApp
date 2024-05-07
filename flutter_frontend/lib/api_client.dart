import 'dart:convert';
import 'dart:developer';
import 'package:flutter_frontend/api_endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class ApiClient {
  static const _jwtKey = 'jwt';
  static const _jwtRefreshKey = 'jwtRefresh';
  static const _storage = FlutterSecureStorage();

  static Future sendRequest(String path,
      {Function methodFun = http.get,
      Map<String, dynamic>? body,
      bool authorizedRequest = false}) async {
    try {
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

      http.Response response;
      if (body != null) {
        response =
            await methodFun(url, headers: headers, body: jsonEncode(body));
      } else {
        response = await methodFun(url, headers: headers);
      }

      final result =
          jsonDecode(response.body.isNotEmpty ? response.body : '{}');

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

  static Future<String> postPhoto(String path, http.MultipartFile file) async {
    final url = Uri.parse(path);
    final request = http.MultipartRequest("POST", url);
    request.headers.addAll({"Authorization": "Bearer ${await getUserToken()}"});
    request.files.add(file);

    final response = await request.send();
    final result = jsonDecode(await response.stream.bytesToString());

    if (response.statusCode >= 400) {
      return Future.error(
          result.containsKey('message') ? result['message'] : result['detail']);
    }

    return result;
  }

  static Future login(String jwt, String refreshToken) async {
    await _storage.write(key: _jwtKey, value: jwt);
    await _storage.write(key: _jwtRefreshKey, value: refreshToken);
  }

  static void logout() async {
    await _storage.deleteAll();
  }

  static Future<String?> getUserToken() async {
    final jwt = await _storage.read(key: _jwtKey);
    final refreshToken = await _storage.read(key: _jwtRefreshKey);

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
