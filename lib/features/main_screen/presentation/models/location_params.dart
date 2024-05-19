import 'package:json_annotation/json_annotation.dart';
import 'package:weather_nearby/features/main_screen/data/models/response/weather/coords.dart';
import 'package:weather_nearby/features/main_screen/data/models/response/weather/sys.dart';

part 'location_params.g.dart';

@JsonSerializable()
class LocationParams {
  final String? cityName;
  final Coords? coords;
  final Sys? sys;

  LocationParams({
    this.coords,
    this.sys,
    this.cityName,
  });

  factory LocationParams.fromJson(Map<String, dynamic> json) => _$LocationParamsFromJson(json);

  Map<String, dynamic> toJson() => _$LocationParamsToJson(this);
}
