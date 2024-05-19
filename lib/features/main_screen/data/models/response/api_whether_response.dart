import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:weather_nearby/core/utils/date_time_extensions.dart';
import 'package:weather_nearby/features/main_screen/data/models/response/weather/coords.dart';
import 'package:weather_nearby/features/main_screen/data/models/response/weather/sys.dart';
import 'package:weather_nearby/features/main_screen/data/models/response/weather/weather.dart';
import 'package:weather_nearby/features/main_screen/data/models/response/weather/weather_data.dart';
import 'package:weather_nearby/features/main_screen/data/models/response/weather/weather_values.dart';
import 'package:weather_nearby/features/main_screen/data/models/response/weather/wind_values.dart';

part 'api_whether_response.g.dart';

@JsonSerializable()
class ApiWhetherResponse {
  @JsonKey(name: 'dt', fromJson: fromSecondsSinceEpochUtc, toJson: toSecondsSinceEpochUtc)
  final DateTime dateTime;
  @JsonKey(name: 'main')
  final WeatherValues weatherValues;
  @JsonKey(name: 'wind')
  final WindValues windValues;
  final List<Weather> weather;
  final int visibility;
  final Sys? sys;
  final Coords? coord;
  @JsonKey(name: 'name')
  final String? cityName;

  ApiWhetherResponse({
    required this.dateTime,
    required this.weatherValues,
    required this.windValues,
    required this.weather,
    required this.visibility,
    this.sys,
    this.coord,
    this.cityName,
  });

  factory ApiWhetherResponse.fromJson(Map<String, dynamic> json) => _$ApiWhetherResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ApiWhetherResponseToJson(this);
}

extension ApiWhetherResponseExtension on ApiWhetherResponse {
  WeatherData get weatherData => WeatherData.fromJson(jsonDecode(jsonEncode(toJson())));
}
