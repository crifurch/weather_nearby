import 'package:json_annotation/json_annotation.dart';

part 'wind_values.g.dart';

@JsonSerializable()
class WindValues {
  final double speed;
  final double deg;
  final double? gust;

  WindValues({
    required this.speed,
    required this.deg,
    required this.gust,
  });

  factory WindValues.fromJson(Map<String, dynamic> json) => _$WindValuesFromJson(json);

  Map<String, dynamic> toJson() => _$WindValuesToJson(this);
}
