import 'dart:convert';

import 'package:grocery_flutter/helpers/response_success.dart';
import 'package:grocery_flutter/http/auth/auth_controller.dart';
import 'package:grocery_flutter/http/item/create_item_model.dart';
import 'package:grocery_flutter/http/social/request_result.dart';
import 'package:grocery_flutter/models/category_model.dart';
import 'package:grocery_flutter/models/grocery_list_item_display.dart';
import 'package:grocery_flutter/state/global_state.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'item_controller.g.dart';

const String baseUrl = AuthController.baseUrl;

@riverpod
Future<List<CategoryModel>> getItemsInGroup(Ref ref) async {
  final url = Uri.parse("$baseUrl/api/item/by-group");
  final response = await http.get(
    url,
    headers: {"Authorization": "Bearer $jwt"},
  );
  return (jsonDecode(response.body) as List)
      .map(
        (category) => CategoryModel.fromJson(category as Map<String, dynamic>),
      )
      .toList();
}

@riverpod
Future<String> createItem(Ref ref, CreateItemModel newItem) async {
  final url = Uri.parse("$baseUrl/api/item");
  final response = await http.post(
    url,
    headers: {
      "Authorization": "Bearer $jwt",
      "Content-Type": "application/json",
    },
    body: newItem.toJson(),
  );
  if (response.isSuccess()) {
    return (response.body);
  }
  throw Exception();
}

@riverpod
Future<RequestResult<List<GroceryListItemDisplay>>> searchItems(
  Ref ref,
  String query,
) async {
  final url = Uri.parse("$baseUrl/api/item/search/$query");
  final response = await http.get(
    url,
    headers: {"Authorization": "Bearer $jwt"},
  );
  if (!response.isSuccess()) {
    throw Exception();
  }
  return RequestSuccess(
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
