part of 'weather_bloc.dart';

@freezed
class WeatherState with _$WeatherState {
  const factory WeatherState({
    @Default(false) bool isLoading,
    WeatherData? currentWeather,
    @Default({}) Map<int, List<WeatherData>> forecastWeather,
    RequestingLocation? requestingLocation,
  }) = _WeatherState;
}

extension WeatherStateExtension on WeatherState {
  int get forecastDays => forecastWeather.keys.length;
}
