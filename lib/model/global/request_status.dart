import 'package:dutapi/model/global/request_code.dart';

class RequestStatus<T> {
  RequestCode requestCode = RequestCode.unknown;
  int statusCode = 0;
  String sessionId = '';
  T? data;
}
