import 'package:json_annotation/json_annotation.dart';
import 'package:weather_nearby/core/utils/date_time_extensions.dart';
import 'package:weather_nearby/features/main_screen/data/models/response/weather/coords.dart';

part 'city.g.dart';

@JsonSerializable()
class City {
  final String? name;
  final Coords? coord;

  @JsonKey(fromJson: fromSecondsSinceEpochUtc, toJson: toSecondsSinceEpochUtc)
  final DateTime? sunrise;
  @JsonKey(fromJson: fromSecondsSinceEpochUtc, toJson: toSecondsSinceEpochUtc)
  final DateTime? sunset;

  City({
    this.name,
    this.coord,
    this.sunrise,
    this.sunset,
  });

  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);

  Map<String, dynamic> toJson() => _$CityToJson(this);
}
