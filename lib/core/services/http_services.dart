import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:staywise_frontend/core/services/storage_services.dart';

class HttpService {
  final _client = http.Client();

  Future<http.Response> post(String url, Map<String, dynamic> body) async {
    final headers = {'Content-Type': 'application/json'};
    return _client.post(Uri.parse(url), body: jsonEncode(body), headers: headers);
  }

  Future<http.Response> get(String url) async {
    final token = await StorageService.getToken();
    final headers = {'Authorization': 'Bearer $token'};
    return _client.get(Uri.parse(url), headers: headers);
  }
}
