class WeatherRequestParam {
  final String? query;
  final double? lat;
  final double? lon;
  final int? cityId;

  const WeatherRequestParam._({
    this.query,
    this.lat,
    this.lon,
    this.cityId,
  });

  factory WeatherRequestParam.query({
    required String query,
  }) =>
      WeatherRequestParam._(query: query);

  factory WeatherRequestParam.coords({
    required double lat,
    required double lon,
  }) =>
      WeatherRequestParam._(
        lat: lat,
        lon: lon,
      );

  factory WeatherRequestParam.city({
    required int? cityId,
  }) =>
      WeatherRequestParam._(
        cityId: cityId,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        if (query != null) 'q': query,
        if (lat != null) 'lat': lat,
        if (lon != null) 'lon': lon,
        if (cityId != null) 'id': cityId,
      };

}
