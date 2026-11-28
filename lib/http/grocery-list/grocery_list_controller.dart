import 'dart:convert';

import 'package:grocery_flutter/helpers/response_success.dart';
import 'package:grocery_flutter/http/auth/auth_controller.dart';
import 'package:grocery_flutter/models/grocery_list_item.dart';
import 'package:grocery_flutter/http/social/request_result.dart';
import 'package:grocery_flutter/models/category_model.dart';
import 'package:grocery_flutter/models/grocery_list_display.dart';
import 'package:grocery_flutter/models/grocery_list_item_display.dart';
import 'package:grocery_flutter/state/global_state.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'grocery_list_controller.g.dart';

// class GroceryListController {
const String baseUrl = AuthController.baseUrl;
// final String jwt;
// GroceryListController(this.jwt);

@Riverpod(keepAlive: true)
Future<List<GroceryListDisplay>> getAllLists(Ref ref) async {
  final uri = Uri.parse("$baseUrl/api/grocery-list/get-all-lists");
  final response = await http.get(
    uri,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $jwt",
    },
  );
  return (jsonDecode(response.body) as List)
      .map((e) => GroceryListDisplay.fromJson(e))
      .toList();
}

@Riverpod(keepAlive: true)
Future<List<GroceryListItemDisplay>> getListInfo(Ref ref, String listId) async {
  final uri = Uri.parse("$baseUrl/api/grocery-list/get-list/$listId");
  final response = await http.get(
    uri,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $jwt",
    },
  );
  return (jsonDecode(response.body) as List)
      .map((e) => GroceryListItemDisplay.fromJson(e))
      .toList();
}

Future<RequestResult<void>> deleteList(String id) async {
  try {
    final uri = Uri.parse("$baseUrl/api/grocery-list/$id");
    final response = await http.delete(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $jwt",
      },
    );
    return switch (response.statusCode) {
      200 => RequestSuccess(null),
      _ => RequestResponseError(response),
    };
  } catch (error) {
    return RequestConnectionError(error as Exception);
  }
}

Future<RequestResult<void>> createList(List<CategoryModel> categories) async {
  try {
    List<NewGroceryListItem> items = [];
    for (var category in categories) {
      items.addAll(
        category.items
            .where((item) => item.quantity > 0)
            .map((e) => NewGroceryListItem(itemId: e.id, quantity: e.quantity)),
      );
    }
    final String json =
        '[${items.map((e) => '{"itemId":"${e.itemId}","quantity":"${e.quantity}"}').join(',')}]';

    final uri = Uri.parse("$baseUrl/api/grocery-list/create-list");
    final response = await http.post(
      uri,
      headers: {
        "Authorization": "Bearer $jwt",
        "Content-Type": "application/json",
      },
      body: json,
    );
    return switch (response.statusCode) {
      200 => RequestSuccess(null),
      _ => RequestResponseError(response),
    };
  } catch (error) {
    return RequestConnectionError(error as Exception);
  }
}
