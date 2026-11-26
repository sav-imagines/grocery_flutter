import 'package:grocery_flutter/helpers/response_success.dart';
import 'package:grocery_flutter/http/auth/login_model.dart';
import 'package:grocery_flutter/http/social/request_result.dart';
import 'package:http/http.dart' as http;

class AuthController {
  static const String baseUrl = "https://grocery.savimagines.nl";
  // static const String baseUrl = "http://192.168.1.111:7020";

  static Future<RequestResult<String>> login(LoginModel model) async {
    try {
      final uri = Uri.parse("$baseUrl/api/auth/login");
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: model.toJson(),
      );

      if (response.isSuccess()) return RequestSuccess(response.body);
      return RequestResponseError(response);
    } catch (error) {
      return RequestConnectionError(error as Exception);
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
      if (response.isSuccess()) {
        return RequestSuccess(null);
      }
      return RequestResponseError(response);
    } catch (error) {
      return RequestConnectionError(error as Exception);
    }
  }
}
