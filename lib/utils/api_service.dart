import 'dart:convert';
import 'dart:developer'; // Import this for logging
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService({
    required this.baseUrl,
  });

  Future<Map<String, dynamic>> get(String endpoint,
      {Map<String, String>? headers}) async {
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {...defaultHeaders, if (headers != null) ...headers},
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> post(String endpoint,
      {Map<String, String>? headers, dynamic body}) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {...defaultHeaders, if (headers != null) ...headers},
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> put(String endpoint,
      {Map<String, String>? headers, dynamic body}) async {
    log('PUT request to: $baseUrl$endpoint'); // Log the request endpoint
    log('Headers: ${headers ?? defaultHeaders}'); // Log headers
    log('Body: ${jsonEncode(body)}'); // Log the request body

    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: {...defaultHeaders, if (headers != null) ...headers},
      body: jsonEncode(body),
    );

    log('Response Status: ${response.statusCode}'); // Log response status
    log('Response Body: ${response.body}'); // Log the response body

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> delete(String endpoint,
      {Map<String, String>? headers}) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: {...defaultHeaders, if (headers != null) ...headers},
    );
    return _handleResponse(response);
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    log('Response Status: ${response.statusCode}'); // Log the response status
    log('Response Body: ${response.body}'); // Log the response body

    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        final decodedResponse = jsonDecode(response.body);
        log('Decoded Response: $decodedResponse'); // Log the decoded response
        return decodedResponse;
      } catch (e) {
        log('Error decoding response body: $e'); // Log any decoding errors
        throw Exception('Error decoding response body');
      }
    } else {
      log('Error: ${response.statusCode}, ${response.body}'); // Log error status and body
      throw Exception('Error: ${response.statusCode}, ${response.body}');
    }
  }

  Map<String, String> get defaultHeaders => {
        'Content-Type': 'application/json',
      };
}
