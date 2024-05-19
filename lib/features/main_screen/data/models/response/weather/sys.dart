import 'package:json_annotation/json_annotation.dart';
import 'package:weather_nearby/core/utils/date_time_extensions.dart';

part 'sys.g.dart';

@JsonSerializable()
class Sys {
  @JsonKey(fromJson: fromSecondsSinceEpochUtc, toJson: toSecondsSinceEpochUtc)
  final DateTime? sunrise;
  @JsonKey(fromJson: fromSecondsSinceEpochUtc, toJson: toSecondsSinceEpochUtc)
  final DateTime? sunset;

  Sys({
    this.sunrise,
    this.sunset,
  });

  factory Sys.fromJson(Map<String, dynamic> json) => _$SysFromJson(json);

  Map<String, dynamic> toJson() => _$SysToJson(this);
}
