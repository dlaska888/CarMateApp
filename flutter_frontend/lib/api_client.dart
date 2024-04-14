import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class ApiClient {
  static Future sendRequest(String path, Map<String, String> body) async {
    try {
      final url = Uri.parse(path);
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode(body));
      final result = jsonDecode(response.body);

      if (response.statusCode >= 400) {
        return Future.error(result.containsKey('message')
            ? result['message']
            : result['detail']);
      }

      return result;
    } catch (e) {
      // Use a logging library to log the error
      log('Error: $e');
      return Future.error('Something went wrong');
    }
  }
}
