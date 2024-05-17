import 'package:dio/dio.dart';

class ApiKeyInterceptor extends Interceptor {
  final String _apiKey;

  ApiKeyInterceptor({
    required String apiKey,
  }) : _apiKey = apiKey;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters.putIfAbsent('APPID', () => _apiKey);
    handler.next(options);
  }
}
