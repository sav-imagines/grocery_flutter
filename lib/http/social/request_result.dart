import 'package:grocery_flutter/helpers/response_success.dart';
import 'package:http/http.dart';

sealed class RequestResult<T> {
  static RequestResult<void> empty<T>(Response response) {
    if (response.isSuccess())
      return RequestSuccess(null);
    else
      return RequestResponseError(response);
  }
}

class RequestSuccess<T> implements RequestResult<T> {
  final T result;
  RequestSuccess(this.result);

  @override
  String toString() {
    return result.toString();
  }
}

class RequestError<T> implements RequestResult<T> {
  final String error;
  RequestError(this.error);

  String title() => 'Generic Error';
  @override
  String toString() {
    return error == '' ? title() : error;
  }
}

// the request completed but the server was unhappy
class RequestResponseError<T> extends RequestError<T> {
  final Response response;

  RequestResponseError(this.response)
    : super(response.reasonPhrase ?? response.statusCode.toString());

  @override
  String title() => '${response.reasonPhrase}';

  @override
  String toString() =>
      'HTTP Error ${response.statusCode} ${response.reasonPhrase} occurred.\nReason: ${response.body}';
}

// the server was not reached
class RequestConnectionError<T> extends RequestError<T> {
  RequestConnectionError(Exception? err) : super(err.toString());

  @override
  String title() => 'Connection Error';
}
