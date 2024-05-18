import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:weather_nearby/core/mapper/data_mapper.dart';
import 'package:weather_nearby/features/data/models/requesting_location.dart';
import 'package:weather_nearby/features/main_screen/data/models/request/weather_request_param.dart';
import 'package:weather_nearby/features/main_screen/data/models/response/whether/weather_data.dart';
import 'package:weather_nearby/features/main_screen/data/weather_repository.dart';

part 'weather_bloc.freezed.dart';

part 'weather_event.dart';

part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository _weatherRepository;
  final DataMapper<WeatherRequestParam, RequestingLocation> _weatherRequestParamMapper;

  WeatherBloc({
    required WeatherRepository weatherRepository,
    required DataMapper<WeatherRequestParam, RequestingLocation> weatherRequestParamMapper,
  })  : _weatherRepository = weatherRepository,
        _weatherRequestParamMapper = weatherRequestParamMapper,
        super(const WeatherState()) {
    on<WeatherEvent>(
      (event, emit) => event.when<Future<void>>(
        loadData: (location) => _loadData(location, emit),
        updateAll: () => _updateAll(emit),
        updateCurrentWeather: () => _updateCurrentWeather(emit),
      ),
    );
  }

  Future<void> _loadData(RequestingLocation? location, Emitter<WeatherState> emit) async {
    final requestingLocation = location ??
        state.requestingLocation ??
        RequestingLocation(
          location: 'Минск',
        );
    emit(state.copyWith(
      isLoading: true,
      requestingLocation: requestingLocation,
    ));
    await _updateAll(emit);
    emit(state.copyWith(
      isLoading: false,
    ));
  }

  Future<void> _updateAll(Emitter<WeatherState> emit) async {
    if (state.requestingLocation == null) {
      return;
    }
    final forecastResponse = await _weatherRepository.getForecast(
      _weatherRequestParamMapper.mapToSecond(state.requestingLocation!),
    );
    if (forecastResponse.isSuccess) {
      final forecast = forecastResponse.castedData!;
      final groupListsBy =
          forecast.groupListsBy<int>((element) => element.dateTime.difference(DateTime.timestamp()).inDays);
      emit(state.copyWith(forecastWeather: groupListsBy));
    }
    await _updateCurrentWeather(emit);
    emit(state.copyWith(
      isLoading: false,
    ));
  }

  Future<void> _updateCurrentWeather(Emitter<WeatherState> emit) async {
    if (state.requestingLocation == null) {
      return;
    }
    final requestingLocation = state.requestingLocation!;
    final currentWeatherResponse = await _weatherRepository.getCurrentWeather(
      _weatherRequestParamMapper.mapToSecond(requestingLocation),
    );
    emit(state.copyWith(
      currentWeather: currentWeatherResponse.castedData ?? state.currentWeather,
    ));
  }
}
