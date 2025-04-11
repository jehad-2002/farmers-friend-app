// api_service.dart

import 'dart:convert';
import 'package:farmersfriendapp/core/models/weather.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  static const String _baseUrl = "http://api.weatherapi.com/v1/forecast.json";
  static const String _apiKey = "4815bb9907ec43688e8201803241101";
  static const String _days = "14";

  Future<WeatherResponse> fetchWeather(String city) async {
    final url = Uri.parse(
        "$_baseUrl?key=$_apiKey&q=$city&days=$_days&aqi=yes&alerts=yes");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return WeatherResponse.fromJson(data);
    } else {
      throw Exception("فشل تحميل بيانات الطقس");
    }
  }
}


