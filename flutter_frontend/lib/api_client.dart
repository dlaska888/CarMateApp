import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  static Future sendRequest(
    String path, {
    Function methodFun = http.get,
    Map<String, String>? body,
  }) async {
    try {
      const storage = FlutterSecureStorage();

      final url = Uri.parse(path);
      final jwt = await storage.read(key: 'jwt');
      http.Response response;

      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      };

      if (jwt != null) {
        headers['Authorize'] = 'Bearer $jwt';
      }

      if (body != null) {
        response = await methodFun(url, headers: headers, body: jsonEncode(body));
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
}
