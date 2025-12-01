import 'package:http/http.dart' as http;

class Api {
  Future<http.Response> get(String url) async {
    return await http.get(Uri.parse(url));
  }

  Future<http.Response> post(String url, Map<String, dynamic> body) async {
    return await http.post(Uri.parse(url), body: body);
  }

  Future<http.Response> put(String url, Map<String, dynamic> body) async {
    return await http.put(Uri.parse(url), body: body);
  }

  Future<http.Response> delete(String url) async {
    return await http.delete(Uri.parse(url));
  }
}
