import 'dart:convert';

import 'package:grocery_flutter/http/auth/auth_controller.dart';
import 'package:grocery_flutter/http/item/create_item_model.dart';
import 'package:grocery_flutter/http/social/request_result.dart';
import 'package:grocery_flutter/models/category_model.dart';
import 'package:grocery_flutter/models/grocery_list_item_display.dart';
import 'package:http/http.dart' as http;

class ItemController {
  final String jwt;
  static const String baseUrl = AuthController.baseUrl;

  ItemController({required this.jwt});

  Future<RequestResult<List<CategoryModel>?>> getItemsInGroup() async {
    try {
      final url = Uri.parse("$baseUrl/api/item/by-group");
      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $jwt"},
      );
      if (response.statusCode == 200) {
        return RequestSuccess(
          result:
              response.body.isEmpty
                  ? null
                  : (jsonDecode(response.body) as List)
                      .map(
                        (category) => CategoryModel.fromJson(
                          category as Map<String, dynamic>,
                        ),
                      )
                      .toList(),
        );
      }
      return RequestError(
        error:
            "Returned status ${response.statusCode} with message ${response.body}",
      );
    } catch (error) {
      return RequestError(error: error.toString());
    }
  }

  Future<RequestResult<String>> createItem(CreateItemModel newItem) async {
    try {
      final url = Uri.parse("$baseUrl/api/item");
      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $jwt",
          "Content-Type": "application/json",
        },
        body: newItem.toJson(),
      );
      if (response.statusCode == 200) {
        return RequestSuccess(result: response.body);
      }
      return RequestError(
        error:
            "Returned status ${response.statusCode} with message ${response.body}",
      );
    } catch (error) {
      return RequestErrorConnectionError(error.toString());
    }
  }

  Future<RequestResult<List<GroceryListItemDisplay>>> searchItems(
    String query,
  ) async {
    try {
      final url = Uri.parse("$baseUrl/api/item/search/$query");
      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $jwt"},
      );
      if (response.statusCode == 200) {
        return RequestSuccess(
          result:
              response.body.isEmpty
                  ? List.empty(growable: true)
                  : (jsonDecode(response.body) as List)
                      .map(
                        (item) => GroceryListItemDisplay(
                          id: item['id'],
                          name: item['name'],
                          quantity: 1,
                          categoryId: item['categoryId'],
                          categoryName: item['categoryName'],
                        ),
                      )
                      .toList(),
        );
      }
      return RequestError(
        error:
            "Returned status ${response.statusCode} with message ${response.body}",
      );
    } catch (error) {
      return RequestError(error: error.toString());
    }
  }
}
