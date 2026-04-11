import 'package:grocery_flutter/http/auth/auth_controller.dart';
import 'package:grocery_flutter/http/social/request_result.dart';
import 'package:http/http.dart' as http;

class CategoryController {
  static const String baseUrl = AuthController.baseUrl;
  final String jwt;

  const CategoryController(this.jwt);

  Future<RequestResult<String>> createCategory(String categoryName) async {
    try {
      final uri = Uri.parse("$baseUrl/api/category");
      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $jwt",
        },
        body: '"$categoryName"',
      );
      return switch (response.statusCode) {
        200 => RequestSuccess(response.body),
        _ => RequestResponseError(response),
      };
    } catch (error) {
      return RequestConnectionError(error as Exception);
    }
  }

  Future<RequestResult<void>> deleteCategory(String categoryId) async {
    try {
      final uri = Uri.parse("$baseUrl/api/category?id=$categoryId");
      final response = await http.delete(
        uri,
        headers: {"Authorization": "Bearer $jwt"},
      );
      return RequestResult.empty(response);
    } catch (error) {
      return RequestConnectionError(error as Exception);
    }
  }
}
