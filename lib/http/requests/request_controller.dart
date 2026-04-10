import 'dart:convert';

import 'package:grocery_flutter/helpers/response_success.dart';
import 'package:grocery_flutter/http/auth/auth_controller.dart';
import 'package:grocery_flutter/http/requests/request_item_model.dart';
import 'package:grocery_flutter/http/social/request_result.dart';
import 'package:grocery_flutter/models/short_item.dart';
import 'package:http/http.dart' as http;

class RequestController {
  static const String baseUrl = AuthController.baseUrl;
  final String jwt;

  get usualHeaders => {
    "Content-Type": "application/json",
    "Authorization": "Bearer $jwt",
  };

  RequestController(this.jwt);

  Future<RequestResult<List<ShortItem>>> getRequestedItems() async {
    try {
      final uri = Uri.parse("$baseUrl/api/requests");
      final response = await http.get(headers: usualHeaders, uri);
      if (response.isSuccess())
        return RequestSuccess(
          (jsonDecode(response.body) as List)
              .map((e) => ShortItem.fromJson(e))
              .toList(),
        );
      return RequestResponseError(response);
    } catch (error) {
      return RequestConnectionError(error as Exception);
    }
  }

  Future<RequestResult<void>> requestItem(ShortItem requestItem) async {
    try {
      final url = Uri.parse("$baseUrl/api/requests");
      final body = RequestItemModel.fromShortItem(requestItem).toJson();
      final response = await http.post(url, headers: usualHeaders, body: body);
      return RequestResult.empty(response);
    } catch (error) {
      return RequestConnectionError(error as Exception);
    }
  }

  Future<RequestResult<void>> updateItems(List<ShortItem> items) async {
    try {
      // TODO: consider a batch endpoint

      final url = Uri.parse("$baseUrl/api/requests");
      for (var item in items) {
        final body = RequestItemModel.fromShortItem(item).toJson();
        final response = await http.post(
          url,
          headers: usualHeaders,
          body: body,
        );
        if (!response.isSuccess()) {
          return RequestResponseError(response);
        }
      }
      return RequestSuccess(null);
    } catch (error) {
      return RequestConnectionError(error as Exception);
    }
  }

  Future<RequestResult<void>> deleteAllRequests() async {
    try {
      final url = Uri.parse("$baseUrl/api/requests/reset");
      final response = await http.delete(url, headers: usualHeaders);
      return RequestResult.empty(response);
    } catch (error) {
      return RequestConnectionError(error as Exception);
    }
  }
}
