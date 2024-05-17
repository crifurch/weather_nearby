import 'package:json_annotation/json_annotation.dart';

part 'weather_values.g.dart';

@JsonSerializable()
class WeatherValues {
  final double temp;
  @JsonKey(name: 'feels_like')
  final double tempFeelsLike;
  @JsonKey(name: 'temp_min')
  final double tempMin;
  @JsonKey(name: 'temp_max')
  final double tempMax;
  final double pressure;
  final double humidity;

  WeatherValues({
    required this.temp,
    required this.tempFeelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
  });

  factory WeatherValues.fromJson(Map<String, dynamic> json) => _$WeatherValuesFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherValuesToJson(this);
}
