import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  Future sendRequest(String path, Map<String, String> body) async {
    final url = Uri.parse(path);
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(body));
    final result = jsonDecode(response.body);

    if (response.statusCode >= 400) {
      return Future.error(
          result.containsKey('message') ? result['message'] : result['detail']);
    }

    return result;
  }
}
