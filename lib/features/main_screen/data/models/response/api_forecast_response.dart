import 'package:json_annotation/json_annotation.dart';
import 'package:weather_nearby/features/main_screen/data/models/response/weather/city.dart';
import 'package:weather_nearby/features/main_screen/data/models/response/weather/weather_data.dart';

part 'api_forecast_response.g.dart';

@JsonSerializable()
class ApiForecastResponse {
  @JsonKey(name: 'list')
  final List<WeatherData> weatherData;
  final City? city;

  ApiForecastResponse({
    required this.weatherData,
    this.city,
  });

  factory ApiForecastResponse.fromJson(Map<String, dynamic> json) => _$ApiForecastResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ApiForecastResponseToJson(this);
}
