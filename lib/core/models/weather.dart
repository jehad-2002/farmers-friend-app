class Weather {
  final Location location;
  final Current current;
  final Forecast forecast;

  Weather({
    required this.location,
    required this.current,
    required this.forecast,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      location: Location.fromJson(json["location"]),
      current: Current.fromJson(json["current"]),
      forecast: Forecast.fromJson(json["forecast"]),
    );
  }
}

class Location {
  final String name;
  final String region;
  final String country;
  final double lat;
  final double lon;
  final String tzId;
  final int localtimeEpoch;
  final String localtime;

  Location({
    required this.name,
    required this.region,
    required this.country,
    required this.lat,
    required this.lon,
    required this.tzId,
    required this.localtimeEpoch,
    required this.localtime,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json["name"],
      region: json["region"],
      country: json["country"],
      lat: (json["lat"] as num).toDouble(),
      lon: (json["lon"] as num).toDouble(),
      tzId: json["tz_id"],
      localtimeEpoch: json["localtime_epoch"],
      localtime: json["localtime"],
    );
  }
}

class Current {
  final String lastUpdated;
  final double tempC;
  final double tempF;
  final int humidity;
  final double windKph;
  final Condition condition;

  Current({
    required this.lastUpdated,
    required this.tempC,
    required this.tempF,
    required this.humidity,
    required this.windKph,
    required this.condition,
  });

  factory Current.fromJson(Map<String, dynamic> json) {
    return Current(
      lastUpdated: json["last_updated"],
      tempC: (json["temp_c"] as num).toDouble(),
      tempF: (json["temp_f"] as num).toDouble(),
      humidity: json["humidity"],
      windKph: (json["wind_kph"] as num).toDouble(),
      condition: Condition.fromJson(json["condition"]),
    );
  }
}

class Condition {
  final String text;
  final String icon;
  final int code;

  Condition({
    required this.text,
    required this.icon,
    required this.code,
  });

  factory Condition.fromJson(Map<String, dynamic> json) {
    return Condition(
      text: json["text"],
      icon: json["icon"],
      code: json["code"],
    );
  }
}

class Forecast {
  final List<ForecastDay> forecastDay;

  Forecast({
    required this.forecastDay,
  });

  factory Forecast.fromJson(Map<String, dynamic> json) {
    var list = json["forecastday"] as List;
    List<ForecastDay> forecastDays =
        list.map((e) => ForecastDay.fromJson(e)).toList();
    return Forecast(
      forecastDay: forecastDays,
    );
  }
}

class ForecastDay {
  final String date;
  final Day day;
  final Astro astro;

  ForecastDay({
    required this.date,
    required this.day,
    required this.astro,
  });

  factory ForecastDay.fromJson(Map<String, dynamic> json) {
    return ForecastDay(
      date: json["date"],
      day: Day.fromJson(json["day"]),
      astro: Astro.fromJson(json["astro"]),
    );
  }
}

class Day {
  final double maxTempC;
  final double minTempC;
  final double avgTempC;
  final Condition condition;

  Day({
    required this.maxTempC,
    required this.minTempC,
    required this.avgTempC,
    required this.condition,
  });

  factory Day.fromJson(Map<String, dynamic> json) {
    return Day(
      maxTempC: (json["maxtemp_c"] as num).toDouble(),
      minTempC: (json["mintemp_c"] as num).toDouble(),
      avgTempC: (json["avgtemp_c"] as num).toDouble(),
      condition: Condition.fromJson(json["condition"]),
    );
  }
}

class Astro {
  final String sunrise;
  final String sunset;

  Astro({
    required this.sunrise,
    required this.sunset,
  });

  factory Astro.fromJson(Map<String, dynamic> json) {
    return Astro(
      sunrise: json["sunrise"],
      sunset: json["sunset"],
    );
  }
}

class WeatherResponse {
  final Weather weather;

  WeatherResponse({required this.weather});

  factory WeatherResponse.fromJson(Map<String, dynamic> json) {
    return WeatherResponse(weather: Weather.fromJson(json));
  }

  String get resolvedAddress =>
      "${weather.location.name}, ${weather.location.country}";

  List<ForecastDay> get days => weather.forecast.forecastDay;

  double get currentTemp => weather.current.tempF;

  int get currentHumidity => weather.current.humidity;

  double get currentWindSpeed => weather.current.windKph;

  String get currentCondition => weather.current.condition.text;
}
