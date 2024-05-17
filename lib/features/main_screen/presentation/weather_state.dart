part of 'weather_bloc.dart';

@freezed
class WeatherState with _$WeatherState {
  const factory WeatherState({
    @Default(false) bool isLoading,
    WeatherData? currentWeather,
    @Default([])
    List<WeatherData> forecastWeather,
    RequestingLocation? requestingLocation,
  }) = _WeatherState;
}
