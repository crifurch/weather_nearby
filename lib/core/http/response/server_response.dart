import 'package:meta/meta.dart';

@immutable
class ServerResponse {
  final int code;
  final Map<String, dynamic>? data;

  bool get isSuccess => code >= 200 && code <= 204;

  const ServerResponse(this.code, {this.data});
}
