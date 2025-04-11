import 'package:farmersfriendapp/core/errors/failures.dart';
import 'package:farmersfriendapp/core/models/weather.dart';
import 'package:farmersfriendapp/features/weather/domain/repositories/weather_repository.dart';
import 'package:dartz/dartz.dart';

class GetWeather {
  final WeatherRepository repository;

  GetWeather(this.repository);

  Future<Either<Failure, WeatherResponse>> call(String city) async {
    return await repository.getWeather(city);
  }
}
