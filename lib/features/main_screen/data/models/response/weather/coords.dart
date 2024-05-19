import 'package:json_annotation/json_annotation.dart';

part 'coords.g.dart';

@JsonSerializable()
class Coords {
  final double lat;
  final double lon;

  Coords({
    required this.lat,
    required this.lon,
  });

  factory Coords.fromJson(Map<String, dynamic> json) => _$CoordsFromJson(json);

  Map<String, dynamic> toJson() => _$CoordsToJson(this);
}
