import 'package:farmersfriendapp/core/errors/failures.dart';
import 'package:farmersfriendapp/core/models/weather.dart';
import 'package:dartz/dartz.dart';

abstract class WeatherRepository {
  Future<Either<Failure, WeatherResponse>> getWeather(String city);
}
