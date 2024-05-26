import 'package:http/http.dart' as http;
import 'dart:convert';

class RegistrationApi {
  static const String baseUrl = 'https://kamal-golang-back-b154d239f542.herokuapp.com/auth';

  static Future<Map<String, dynamic>> sendVerificationCode(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/send-email'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200) {
      return {'status': 'success', 'message': 'Code sent to your email'};
    } else {
      return {'status': 'error', 'message': 'Failed to send verification code'};
    }
  }

  static Future<Map<String, dynamic>> verifyCode(String email, String code) async {
    final response = await http.post(
      Uri.parse('$baseUrl/check-code'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'code': code}),
    );

    if (response.statusCode < 299) {
      return {'status': 'success'};
    } else {
      return {'status': 'error', 'message': 'Invalid verification code'};
    }
  }

  static Future<Map<String, dynamic>> register(String email, String password, String fname, String lname) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'fname': fname,
        'lname': lname,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody['status'] == 'success') {
        return {'status': 'success'};
      } else {
        return {'status': 'error', 'message': responseBody['message'] ?? 'Registration failed'};
      }
    } else {
      return {'status': 'error', 'message': 'Failed to register'};
    }
  }
}
