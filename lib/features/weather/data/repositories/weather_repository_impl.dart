import 'package:farmersfriendapp/core/errors/exceptions.dart';
import 'package:farmersfriendapp/core/errors/failures.dart';
import 'package:farmersfriendapp/core/models/weather.dart';
import 'package:farmersfriendapp/features/weather/data/datasources/weather_remote_datasource.dart';
import 'package:farmersfriendapp/features/weather/domain/repositories/weather_repository.dart';
import 'package:dartz/dartz.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;

  WeatherRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, WeatherResponse>> getWeather(String city) async {
    try {
      final weather = await remoteDataSource.getWeather(city);
      return Right(weather);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on Exception catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }
}
