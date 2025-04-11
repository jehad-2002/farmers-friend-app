import 'package:farmersfriendapp/core/models/weather.dart';
import 'package:equatable/equatable.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object?> get props => [];
}

class WeatherInitial extends WeatherState {
  const WeatherInitial();
}

class WeatherLoadInProgress extends WeatherState {
  const WeatherLoadInProgress();
}

class WeatherLoadSuccess extends WeatherState {
  final WeatherResponse weather;

  const WeatherLoadSuccess(this.weather);

  @override
  List<Object> get props => [weather];
}

class WeatherLoadFailure extends WeatherState {
  final String message;

  const WeatherLoadFailure(this.message);

  @override
  List<Object> get props => [message];
}
