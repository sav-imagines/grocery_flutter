import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:grocery_flutter/http/auth/auth_controller.dart';
import 'package:grocery_flutter/http/recipe/create_recipe_model.dart';
import 'package:grocery_flutter/http/social/request_result.dart';
import 'package:grocery_flutter/models/recipe_info.dart';
import 'package:grocery_flutter/models/short_item.dart';
import 'package:grocery_flutter/state/global_state.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/v4.dart';

part 'recipe_controller.g.dart';

const String baseUrl = AuthController.baseUrl;
// final String jwt;

// RecipeController(this.jwt);

@riverpod
Future<List<RecipeInfo>> getAllRecipes(Ref ref) async {
  final uri = Uri.parse("$baseUrl/api/recipe");
  final response = await http.get(
    uri,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $jwt",
    },
  );
  return (jsonDecode(response.body) as List)
      .map((e) => RecipeInfo.fromJson(e))
      .toList();
}

@riverpod
Future<Uint8List> getPicture(Ref ref, String fileName) async {
  final cacheManager = DefaultCacheManager();
  final cachedFile =
      await (await cacheManager.getFileFromCache(
        "recipePicture/$fileName",
      ))?.file.readAsBytes();
  if (cachedFile != null) return cachedFile;

  final uri = Uri.parse("$baseUrl/api/recipe/picture/$fileName");
  final response = await http.get(
    uri,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $jwt",
    },
  );
  await cacheManager.putFile('recipePicture/$fileName', response.bodyBytes);
  return response.bodyBytes;
}

@riverpod
Future<RequestResult<void>> createRecipe(
  Ref ref,
  CreateRecipeModel recipe,
) async {
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
}

@riverpod
Future<List<ShortItem>> getIngredients(Ref ref, String recipeId) async {
  final uri = Uri.parse("$baseUrl/api/recipe/ingredients/$recipeId");
  final response = await http.get(
    uri,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $jwt",
    },
  );
  return (jsonDecode(response.body) as List)
      .map((e) => ShortItem.fromJson(e))
      .toList();
}
