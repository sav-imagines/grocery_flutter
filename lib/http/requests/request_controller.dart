import 'dart:convert';

import 'package:grocery_flutter/helpers/response_success.dart';
import 'package:grocery_flutter/http/auth/auth_controller.dart';
import 'package:grocery_flutter/http/requests/request_item_model.dart';
import 'package:grocery_flutter/models/short_item.dart';
import 'package:grocery_flutter/state/global_state.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'request_controller.g.dart';

const String baseUrl = AuthController.baseUrl;

get usualHeaders => {
  "Content-Type": "application/json",
  "Authorization": "Bearer $jwt",
};

@riverpod
Future<List<ShortItem>> getRequestedItems(Ref ref) async {
  final uri = Uri.parse("$baseUrl/api/requests");
  final response = await http.get(headers: usualHeaders, uri);
  return ((jsonDecode(response.body) as List)
      .map((e) => ShortItem.fromJson(e))
      .toList());
}

@riverpod
Future<bool> requestItem(Ref ref, ShortItem requestItem) async {
  final url = Uri.parse("$baseUrl/api/requests");
  final body = RequestItemModel.fromShortItem(requestItem).toJson();
  final response = await http.post(url, headers: usualHeaders, body: body);
  if (!response.isSuccess()) {
    throw Exception("Response unsuccessful");
  }
  return true;
}

@riverpod
Future<bool> updateItems(Ref ref, List<ShortItem> items) async {
  // TODO: consider a batch endpoint
  final url = Uri.parse("$baseUrl/api/requests");
  for (var item in items) {
    final body = RequestItemModel.fromShortItem(item).toJson();
    final response = await http.post(url, headers: usualHeaders, body: body);
    if (!response.isSuccess()) {
      throw Exception("Response unsuccessful");
    }
  }
  return true;
}

@riverpod
Future<bool> deleteAllRequests(Ref ref) async {
  final url = Uri.parse("$baseUrl/api/requests/reset");
  final response = await http.delete(url, headers: usualHeaders);
  if (!response.isSuccess()) {
    throw Exception("Response unsuccessful");
  }
  return true;
}
