import 'package:http/http.dart';

extension ResponseSuccess on Response {
  bool isSuccess() => statusCode >= 200 && statusCode < 300;
}

extension StreamedResponseSuccess on StreamedResponse {
  bool isSuccess() => statusCode >= 200 && statusCode < 300;
}
