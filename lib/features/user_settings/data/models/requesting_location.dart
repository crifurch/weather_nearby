import 'package:json_annotation/json_annotation.dart';

part 'requesting_location.g.dart';

@JsonSerializable()
class RequestingLocation {
  final String location;
  final DateTime updatedTimeUTC;

  RequestingLocation({
    required this.location,
    DateTime? updatedTimeUTC,
  }) : updatedTimeUTC = updatedTimeUTC ?? DateTime.now().toUtc();


  factory RequestingLocation.fromJson(Map<String, dynamic> json) => _$RequestingLocationFromJson(json);

  Map<String, dynamic> toJson() => _$RequestingLocationToJson(this);
}
