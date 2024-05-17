import 'package:dio/dio.dart';
import 'package:weather_nearby/core/http/response/complex_response.dart';
import 'package:weather_nearby/core/http/response/handled_response.dart';
import 'package:weather_nearby/core/http/response/response_error.dart';
import 'package:weather_nearby/features/main_screen/data/models/request/weather_request_param.dart';
import 'package:weather_nearby/features/main_screen/data/models/response/whether/weather_data.dart';

class WeatherRepository {
  final Dio _client;

  const WeatherRepository({required Dio client}) : _client = client;

  Future<ComplexResponse<List<WeatherData>>> getForecast(
    WeatherRequestParam requestParam,
  ) async {
    try {
      final response = await _client.get(
        '/forecast',
        queryParameters: requestParam.toMap(),
      );

      var handledResponse = HandledResponse.fromDioResult(response);
      if (handledResponse.isSuccess && response.data['cod'] != '200') {
        handledResponse = ForbiddenError();
      }
      return ComplexResponse.converted(
        handledResponse,
        converter: (data) => (data['list'] as List)
            .map(
              (e) => WeatherData.fromJson(e as Map<String, dynamic>),
            )
            .toList(),
      );
    } on Exception catch (error) {
      return ComplexResponse.fromException(error);
    }
  }

  Future<ComplexResponse<WeatherData>> getCurrentWeather(
    WeatherRequestParam requestParam,
  ) async {
    try {
      final response = await _client.get(
        '/weather',
        queryParameters: requestParam.toMap(),
      );
      var handledResponse = HandledResponse.fromDioResult(response);
      if (handledResponse.isSuccess && response.data['cod'] != '200') {
        handledResponse = ForbiddenError();
      }
      return ComplexResponse.converted(
        HandledResponse.fromDioResult(response),
        converter: (data) => WeatherData.fromJson(response.data),
      );
    } on Exception catch (error) {
      return ComplexResponse.fromException(error);
    }
  }
}
