import 'package:grocery_flutter/http/auth/login_model.dart';
import 'package:grocery_flutter/http/social/request_result.dart';
import 'package:http/http.dart' as http;

class AuthController {
  // static const String baseUrl = "https://api.boodschappen-app.nl";
  static const String baseUrl = "http://192.168.1.111:7020";

  static Future<RequestResult<String>> login(LoginModel model) async {
    try {
      final uri = Uri.parse("$baseUrl/api/auth/login");
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: model.toJson(),
      );

      if (response.statusCode == 200) {
        return RequestSuccess(result: response.body);
      }
      return RequestError(
        error: 'Server returned a status ${response.statusCode}',
      );
    } catch (error) {
      return RequestError(error: error.toString());
    }
  }

  static Future<RequestResult<void>> isValidToken(String jwt) async {
    try {
      final uri = Uri.parse("$baseUrl/api/auth/check-token");
      final response = await http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $jwt",
        },
      );
      return switch (response.statusCode) {
        200 => RequestSuccess(result: null),
        _ => RequestError(
          error:
              response.body.isEmpty
                  ? "Status ${response.statusCode}: ${response.reasonPhrase}"
                  : "Status ${response.statusCode}: ${response.body}",
        ),
      };
    } catch (error) {
      return RequestErrorConnectionError(error.toString());
    }
  }
}
