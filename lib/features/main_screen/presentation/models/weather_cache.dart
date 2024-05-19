import 'package:json_annotation/json_annotation.dart';
import 'package:weather_nearby/core/utils/date_time_extensions.dart';
import 'package:weather_nearby/features/main_screen/data/models/response/weather/weather_data.dart';
import 'package:weather_nearby/features/main_screen/presentation/models/location_params.dart';

part 'weather_cache.g.dart';

@JsonSerializable()
class WeatherCache {
  @JsonKey(fromJson: fromSecondsSinceEpochUtc, toJson: toSecondsSinceEpochUtc)
  final DateTime cacheTimeUTC;
  final LocationParams? locationParams;
  final Map<int, List<WeatherData>> forecastWeather;
  final WeatherData? currentWeather;

  const WeatherCache({
    required this.cacheTimeUTC,
    this.locationParams,
    this.forecastWeather = const {},
    this.currentWeather,
  });

  factory WeatherCache.fromJson(Map<String, dynamic> json) => _$WeatherCacheFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherCacheToJson(this);
}
