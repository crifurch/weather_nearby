import 'package:dio/dio.dart';
import 'package:weather_nearby/core/localization/string_provider.dart';

class LangInterceptor extends Interceptor {
  final StringProvider _stringProvider;

  LangInterceptor({
    required StringProvider stringProvider,
  }) : _stringProvider = stringProvider;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters.putIfAbsent(
      'lang',
      () => _stringProvider.countryStrings.code,
    );
    handler.next(options);
  }
}
