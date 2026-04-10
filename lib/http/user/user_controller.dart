import 'package:grocery_flutter/http/auth/auth_controller.dart';
import 'package:grocery_flutter/http/social/request_result.dart';
import 'package:grocery_flutter/http/user/account_creation_model.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:uuid/uuid.dart';

class UserController {
  static const String baseUrl = AuthController.baseUrl;

  static Future<RequestResult<void>> createAccount(
    AccountCreationModel model,
  ) async {
    try {
      final uri = Uri.parse("$baseUrl/api/auth/create");
      var request = http.MultipartRequest("POST", uri);
      request.fields.addEntries(model.toStringMap());
      request.files.add(
        http.MultipartFile.fromBytes(
          "ProfilePicture",
          model.pfp,
          contentType: MediaType.parse("image/jpeg"),
          filename: "ProfilePicture-${model.userName}-${Uuid().v4()}.jpeg",
        ),
      );
      final response = await http.Response.fromStream(await request.send());

      return RequestResult.empty(response);
    } catch (error) {
      return RequestConnectionError(error as Exception);
    }
  }
}
