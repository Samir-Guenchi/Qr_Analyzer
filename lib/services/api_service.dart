import 'dart:convert';
import 'package:http/http.dart' as http;

class UrlCheckResult {
  final String status;
  final String url;
  final Map<String, dynamic> domainInfo;

  UrlCheckResult({
    required this.status,
    required this.url,
    required this.domainInfo,
  });

  factory UrlCheckResult.fromJson(Map<String, dynamic> json) {
    return UrlCheckResult(
      status: json['status'],
      url: json['url'],
      domainInfo: json['domain_info'],
    );
  }
}

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<UrlCheckResult> checkUrl(String url) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/check_url'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'url': url}),
    );

    if (response.statusCode == 200) {
      return UrlCheckResult.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to check URL: ${response.statusCode}');
    }
  }
}
