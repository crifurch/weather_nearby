class WeatherRequestParam {
  final String? _query;
  final double? _lat;
  final double? _lon;
  final int? _cityId;

  const WeatherRequestParam._({
    String? query,
    double? lat,
    double? lon,
    int? cityId,
  })  : _query = query,
        _lat = lat,
        _lon = lon,
        _cityId = cityId;

  factory WeatherRequestParam.query({
    required String query,
  }) =>
      WeatherRequestParam._(query: query);

  factory WeatherRequestParam.coords({
    required double? lat,
    required double? lon,
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
        if (_query != null) 'q': _query,
        if (_lat != null) 'lat': _lat,
        if (_lon != null) 'lon': _lon,
        if (_cityId != null) 'id': _cityId,
      };
}
