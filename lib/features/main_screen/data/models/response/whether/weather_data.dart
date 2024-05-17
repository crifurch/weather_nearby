import 'package:json_annotation/json_annotation.dart';
import 'package:weather_nearby/core/utils/date_time_extensions.dart';
import 'package:weather_nearby/features/main_screen/data/models/response/whether/wind_values.dart';

import 'weather.dart';
import 'weather_values.dart';

part 'weather_data.g.dart';

@JsonSerializable()
class WeatherData {
  @JsonKey(name: 'dt', fromJson: fromSecondsSinceEpochUtc)
  final DateTime dateTime;
  @JsonKey(name: 'main')
  final WeatherValues weatherValues;
  @JsonKey(name: 'wind')
  final WindValues windValues;
  final List<Weather> weather;
  final int visibility;

  WeatherData({
    required this.dateTime,
    required this.weatherValues,
    required this.windValues,
    required this.weather,
    required this.visibility,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) => _$WeatherDataFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherDataToJson(this);
}
