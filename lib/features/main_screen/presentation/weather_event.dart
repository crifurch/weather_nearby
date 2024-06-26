part of 'weather_bloc.dart';

@freezed
class WeatherEvent with _$WeatherEvent {
  const factory WeatherEvent.init() = _Init;

  const factory WeatherEvent.loadData({
    RequestingLocation? location,
  }) = _LoadData;

  const factory WeatherEvent.updateAll() = _UpdateAll;

  const factory WeatherEvent.updateCurrentWeather() = _UpdateCurrentWeather;
}
