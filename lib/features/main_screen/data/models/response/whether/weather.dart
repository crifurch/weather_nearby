import 'package:json_annotation/json_annotation.dart';

part 'weather.g.dart';

@JsonSerializable()
class Weather {
  final int id;
  @JsonKey(name: 'main')
  final String name;

  Weather({
    required this.id,
    required this.name,
  });

  factory Weather.fromJson(Map<String, dynamic> json) => _$WeatherFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherToJson(this);
}
