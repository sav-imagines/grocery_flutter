import 'dart:convert';
import 'dart:typed_data';

import 'package:grocery_flutter/helpers/response_success.dart';
import 'package:grocery_flutter/http/auth/auth_controller.dart';
import 'package:grocery_flutter/http/recipe-controller/create_recipe_model.dart';
import 'package:grocery_flutter/http/social/request_result.dart';
import 'package:grocery_flutter/models/recipe_info.dart';
import 'package:grocery_flutter/models/short_item.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:uuid/v4.dart';

class RecipeController {
  static const String baseUrl = AuthController.baseUrl;
  final String jwt;

  RecipeController(this.jwt);

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
      if (response.isSuccess())
        return RequestSuccess(
          (jsonDecode(response.body) as List)
              .map((e) => RecipeInfo.fromJson(e))
              .toList(),
        );
      return RequestResponseError(response);
    } catch (error) {
      return RequestConnectionError(error as Exception);
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
      if (response.isSuccess()) return RequestSuccess(response.bodyBytes);
      return RequestResponseError(response);
    } catch (error) {
      return RequestConnectionError(error as Exception);
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
      final response = await http.Response.fromStream(await request.send());
      return RequestResult.empty(response);
    } catch (error) {
      return RequestConnectionError(error as Exception);
    }
  }

  Future<RequestResult<List<ShortItem>>> getIngredients(String recipeId) async {
    try {
      final uri = Uri.parse("$baseUrl/api/recipe/ingredients/$recipeId");
      final response = await http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $jwt",
        },
      );
      if (response.isSuccess()) {
        return RequestSuccess(
          (jsonDecode(response.body) as List)
              .map((e) => ShortItem.fromJson(e))
              .toList(),
        );
      }
      return RequestResponseError(response);
    } catch (error) {
      return RequestConnectionError(error as Exception);
    }
  }
}
