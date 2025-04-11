import 'package:farmersfriendapp/features/weather/domain/usecases/get_weather.dart';
import 'package:farmersfriendapp/features/weather/presentation/bloc/weather_event.dart';
import 'package:farmersfriendapp/features/weather/presentation/bloc/weather_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const String _defaultCity = "Sanaa";

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetWeather _getWeather;

  WeatherBloc({required GetWeather getWeather})
      : _getWeather = getWeather,
        super(const WeatherInitial()) {
    on<FetchWeatherForDefaultCity>(_onFetchWeatherForDefaultCity);
    on<WeatherRequested>(_onWeatherRequested);
  }

  Future<void> _onFetchWeatherForDefaultCity(
    FetchWeatherForDefaultCity event,
    Emitter<WeatherState> emit,
  ) async {
    await _fetchWeather(_defaultCity, emit);
  }

  Future<void> _onWeatherRequested(
    WeatherRequested event,
    Emitter<WeatherState> emit,
  ) async {
    await _fetchWeather(event.city, emit);
  }

  Future<void> _fetchWeather(String city, Emitter<WeatherState> emit) async {
    if (city.isEmpty) {
      emit(const WeatherLoadFailure("City name cannot be empty"));
      return;
    }
    emit(const WeatherLoadInProgress());
    try {
      final result = await _getWeather(city);
      result.fold(
        (failure) {
          print("WeatherBloc Failure: ${failure.message}");
          emit(WeatherLoadFailure(failure.message));
        },
        (weather) {
          emit(WeatherLoadSuccess(weather));
        },
      );
    } catch (e) {
      print("WeatherBloc Unexpected Error: $e");
      emit(WeatherLoadFailure("An unexpected error occurred: ${e.toString()}"));
    }
  }
}
