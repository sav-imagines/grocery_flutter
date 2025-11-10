import 'dart:convert';
import 'dart:typed_data';

import 'package:grocery_flutter/http/auth/auth_controller.dart';
import 'package:grocery_flutter/http/recipe-controller/create_recipe_model.dart';
import 'package:grocery_flutter/http/social/request_result.dart';
import 'package:grocery_flutter/models/recipe_info.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:uuid/v4.dart';

class RecipeController {
  static const String baseUrl = AuthController.baseUrl;
  final String jwt;

  RecipeController({required this.jwt});

  Future<RequestResult<List<RecipeInfo>>> getAllRecipes() async {
    try {
      final uri = Uri.parse("$baseUrl/api/recipe");
      final response = await http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $jwt",
        },
      );
      return switch (response.statusCode) {
        200 => RequestSuccess(
          result:
              (jsonDecode(response.body) as List)
                  .map((e) => RecipeInfo.fromJson(e))
                  .toList(),
        ),
        _ => RequestError(error: response.body),
      };
    } catch (error) {
      return RequestError(error: error.toString());
    }
  }

  Future<RequestResult<Uint8List>> getPicture(String fileName) async {
    try {
      final uri = Uri.parse("$baseUrl/api/recipe/picture/$fileName");
      final response = await http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $jwt",
        },
      );
      return switch (response.statusCode) {
        200 => RequestSuccess(result: response.bodyBytes),
        _ => RequestError(
          error:
              response.body.isEmpty
                  ? "${response.reasonPhrase}"
                  : response.body,
        ),
      };
    } catch (error) {
      return RequestError(error: error.toString());
    }
  }

  Future<RequestResult<void>> createRecipe(CreateRecipeModel recipe) async {
    try {
      final uri = Uri.parse("$baseUrl/api/recipe");
      var request = http.MultipartRequest("POST", uri);
      request.fields.addEntries(recipe.toStringMap());
      request.headers.addAll(
        Map<String, String>.from({"Authorization": "Bearer $jwt"}),
      );
      request.files.addAll(
        recipe.pictures.map(
          (pic) => http.MultipartFile.fromBytes(
            "Pictures",
            pic,
            contentType: MediaType.parse("image/jpeg"),
            filename: "RecipePicture-${recipe.name}-${UuidV4()}",
          ),
        ),
      );
      final response = await request.send();
      return switch (response.statusCode) {
        200 => RequestSuccess(result: null),
        _ => RequestError(
          error:
              "Status ${response.statusCode} ${response.reasonPhrase}: '${await response.stream.bytesToString()}'",
        ),
      };
    } catch (error) {
      return RequestError(error: error.toString());
    }
  }
}
