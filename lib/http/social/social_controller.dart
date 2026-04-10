import 'dart:convert';
import 'dart:core';

import 'package:grocery_flutter/helpers/response_success.dart';
import 'package:grocery_flutter/http/auth/auth_controller.dart';
import 'package:grocery_flutter/http/social/group_info.dart';
import 'package:grocery_flutter/http/social/invite.dart';
import 'package:grocery_flutter/http/social/request_result.dart';
import 'package:grocery_flutter/http/social/user_info.dart';
import 'package:http/http.dart' as http;

// TODO: Rework to use the RequestResult model

class SocialController {
  static const String baseUrl = AuthController.baseUrl;
  SocialController({required this.jwt});

  final String jwt;
  Future<GroupInfo?> getOwnGroup() async {
    try {
      final uri = Uri.parse("$baseUrl/api/group");
      final response = await http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
          'Accept': 'application/json',
          "Authorization": 'Bearer $jwt',
        },
      );
      if (response.isSuccess()) {
        return GroupInfo.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (error) {
      return null;
    }
  }

  Future<RequestResult<UserInfo>> getMyInfo() async {
    try {
      final uri = Uri.parse("$baseUrl/api/user");
      final response = await http.get(
        uri,
        headers: {
          // "Content-Type": "application/json",
          "Authorization": 'Bearer $jwt',
        },
      );
      if (response.isSuccess()) {
        UserInfo info = UserInfo.fromJson(jsonDecode(response.body));
        return RequestSuccess(info);
      }
      return RequestResponseError(response);
    } catch (error) {
      return RequestConnectionError(error as Exception);
    }
  }

  Future<RequestResult<List<UserInfo>>> getUsersByName(String name) async {
    try {
      final uri = Uri.parse("$baseUrl/api/user/$name");
      final response = await http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer $jwt',
        },
      );
      if (response.isSuccess()) {
        List<UserInfo> list =
            (jsonDecode(response.body) as List)
                .map((e) => UserInfo.fromJson(e))
                .toList();
        return RequestSuccess(list);
      }
      return RequestResponseError(response);
    } catch (error) {
      return RequestConnectionError(error as Exception);
    }
  }

  Future<RequestResult<List<Invite>>> getMyInvites() async {
    try {
      final uri = Uri.parse("$baseUrl/api/group/my-invites");
      final response = await http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer $jwt',
        },
      );
      if (response.isSuccess()) {
        List<Invite> list =
            (jsonDecode(response.body) as List)
                .map((e) => Invite.fromJson(e))
                .toList();
        return RequestSuccess(list);
      }
      return RequestResponseError(response);
    } catch (error) {
      return RequestConnectionError(error as Exception);
    }
  }

  Future<RequestResult<List<Invite>>> getSentInvites() async {
    try {
      final uri = Uri.parse("$baseUrl/api/group/sent-invites");
      final response = await http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer $jwt',
        },
      );
      if (response.isSuccess()) {
        List<Invite> list =
            (jsonDecode(response.body) as List)
                .map((e) => Invite.fromJson(e))
                .toList();
        return RequestSuccess(list);
      }
      return RequestResponseError(response);
    } catch (error) {
      return RequestConnectionError(error as Exception);
    }
  }

  Future<RequestResult<void>> inviteUser(String id) async {
    assert(jwt != '');
    try {
      final uri = Uri.parse("$baseUrl/api/group/send-invite");
      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer $jwt',
        },
        body: '"$id"',
      );
      return RequestResult.empty(response);
    } catch (error) {
      return RequestConnectionError(error as Exception);
    }
  }

  Future<RequestResult<void>> createGroup(String name) async {
    assert(jwt != '');
    try {
      final uri = Uri.parse("$baseUrl/api/group/create");
      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer $jwt',
        },
        body: '{"Name":"$name"}',
      );
      return RequestResult.empty(response);
    } catch (error) {
      return RequestConnectionError(error as Exception);
    }
  }

  Future<RequestResult<void>> leaveGroup() async {
    assert(jwt != '');
    try {
      final uri = Uri.parse("$baseUrl/api/group/leave");
      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer $jwt',
        },
      );
      return RequestResult.empty(response);
    } catch (error) {
      return RequestConnectionError(error as Exception);
    }
  }

  Future<RequestResult<void>> retractInvite(Invite invite) async {
    assert(jwt != '');
    try {
      final uri = Uri.parse("$baseUrl/api/group/retract-invite");
      final response = await http.patch(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer $jwt',
        },
        body: '"${invite.userId}"',
      );
      return RequestResult.empty(response);
    } catch (error) {
      return RequestConnectionError(error as Exception);
    }
  }

  Future<RequestResult<void>> acceptInvite(Invite invite) async {
    assert(jwt != '');
    try {
      final uri = Uri.parse("$baseUrl/api/group/accept-invite");
      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer $jwt',
        },
        body: invite.toJson(),
      );
      return RequestResult.empty(response);
    } catch (error) {
      return RequestConnectionError(error as Exception);
    }
  }

  Future<RequestResult<void>> rejectInvite(Invite invite) async {
    assert(jwt != '');
    try {
      final uri = Uri.parse("$baseUrl/api/group/deny-invite");
      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer $jwt',
        },
        body: invite.toJson(),
      );
      return RequestResult.empty(response);
    } catch (error) {
      return RequestConnectionError(error as Exception);
    }
  }

  Future<RequestResult<bool>> isInvited(String id) async {
    assert(jwt != '');
    try {
      final uri = Uri.parse("$baseUrl/api/group/is-invited/$id");
      final response = await http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer $jwt',
        },
      );
      if (response.isSuccess()) return RequestSuccess(response.body == "true");
      return RequestResponseError(response);
    } catch (error) {
      return RequestConnectionError(error as Exception);
    }
  }
}
