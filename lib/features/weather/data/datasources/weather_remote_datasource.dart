import 'package:farmersfriendapp/core/errors/exceptions.dart';
import 'package:farmersfriendapp/core/models/weather.dart';
import 'package:farmersfriendapp/core/network/api_client.dart';

abstract class WeatherRemoteDataSource {
  Future<WeatherResponse> getWeather(String location);
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final ApiClient apiClient;

  WeatherRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<WeatherResponse> getWeather(String location) async {
    try {
      return await apiClient.fetchWeather(location);
    } catch (e) {
      throw NetworkException(e.toString());
    }
  }
}
