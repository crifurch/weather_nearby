import 'package:weather_nearby/core/mapper/data_mapper.dart';
import 'package:weather_nearby/features/data/models/requesting_location.dart';
import 'package:weather_nearby/features/main_screen/data/models/request/weather_request_param.dart';

class WeatherRequestMapper extends DataMapper<WeatherRequestParam, RequestingLocation> {
  WeatherRequestMapper();

  @override
  RequestingLocation mapToFirst(WeatherRequestParam value) {
    String location;
    if (value.query != null) {
      location = value.query!;
    } else if (value.lat != null && value.lon != null) {
      location = '${value.lat}:${value.lon}';
    } else if (value.cityId != null) {
      location = value.cityId.toString();
    } else {
      location = value.toString();
    }
    return RequestingLocation(location: location);
  }

  @override
  WeatherRequestParam mapToSecond(RequestingLocation value) {
    final location = value.location;
    try {
      if (location.contains(':')) {
        final parts = location.split(':');
        return WeatherRequestParam.coords(
          lat: double.parse(parts[0].replaceFirst(',', '.')),
          lon: double.parse(
            parts[1].replaceFirst(',', '.'),
          ),
        );
      }
    } on Exception {
      //ignore
    }
    final cityId = int.tryParse(location);
    if (cityId != null) {
      WeatherRequestParam.city(cityId: cityId);
    }
    return WeatherRequestParam.query(query: location);
  }
}
