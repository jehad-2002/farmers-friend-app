import 'package:equatable/equatable.dart';

class WeatherResponse extends Equatable {
  final _Weather weather;

  const WeatherResponse({required this.weather});

  factory WeatherResponse.fromJson(Map<String, dynamic> json) {
    try {
      return WeatherResponse(weather: _Weather.fromJson(json));
    } catch (e) {
      print("Error parsing WeatherResponse: $e");
      throw FormatException("Failed to parse Weather JSON: $e");
    }
  }

  String get cityName => weather.location.name;
  String get country => weather.location.country;
  String get resolvedAddress =>
      "${weather.location.name}, ${weather.location.country}";
  List<_ForecastDay> get days => weather.forecast.forecastDay;

  double get currentTempCelsius => weather.current.tempC;
  double get feelsLikeCelsius => weather.current.feelslikeC;
  int get currentHumidity => weather.current.humidity;
  double get currentWindSpeedKph => weather.current.windKph;
  String get currentConditionText => weather.current.condition.text;
  String get currentConditionIconUrl => weather.current.condition.icon;
  int get currentConditionCode => weather.current.condition.code;
  String get lastUpdated => weather.current.lastUpdated;

  @override
  List<Object?> get props => [weather];
}

class _Weather extends Equatable {
  final _Location location;
  final _Current current;
  final _Forecast forecast;
  const _Weather({
    required this.location,
    required this.current,
    required this.forecast,
  });
  factory _Weather.fromJson(Map<String, dynamic> json) {
    if (json['location'] == null ||
        json['current'] == null ||
        json['forecast'] == null) {
      throw FormatException("Missing core components.");
    }
    return _Weather(
        location: _Location.fromJson(json['location']),
        current: _Current.fromJson(json['current']),
        forecast: _Forecast.fromJson(json['forecast']));
  }
  @override
  List<Object?> get props => [location, current, forecast];
}

class _Location extends Equatable {
  final String name, region, country, tzId, localtime;
  final double lat, lon;
  final int localtimeEpoch;
  const _Location(
      {required this.name,
      required this.region,
      required this.country,
      required this.lat,
      required this.lon,
      required this.tzId,
      required this.localtimeEpoch,
      required this.localtime});
  factory _Location.fromJson(Map<String, dynamic> json) {
    if (json['name'] == null) throw FormatException("Missing 'name'.");
    return _Location(
        name: json["name"] ?? '',
        region: json["region"] ?? '',
        country: json["country"] ?? '',
        lat: (json["lat"] as num?)?.toDouble() ?? 0.0,
        lon: (json["lon"] as num?)?.toDouble() ?? 0.0,
        tzId: json["tz_id"] ?? '',
        localtimeEpoch: json["localtime_epoch"] as int? ?? 0,
        localtime: json["localtime"] ?? '');
  }
  @override
  List<Object?> get props =>
      [name, region, country, lat, lon, tzId, localtimeEpoch, localtime];
}

class _Current extends Equatable {
  final String lastUpdated;
  final double tempC, tempF, windKph, feelslikeC;
  final int humidity;
  final _Condition condition;
  const _Current(
      {required this.lastUpdated,
      required this.tempC,
      required this.tempF,
      required this.humidity,
      required this.windKph,
      required this.feelslikeC,
      required this.condition});
  factory _Current.fromJson(Map<String, dynamic> json) {
    if (json['condition'] == null)
      throw FormatException("Missing 'condition'.");
    return _Current(
        lastUpdated: json["last_updated"] ?? '',
        tempC: (json["temp_c"] as num?)?.toDouble() ?? 0.0,
        tempF: (json["temp_f"] as num?)?.toDouble() ?? 0.0,
        humidity: json["humidity"] as int? ?? 0,
        windKph: (json["wind_kph"] as num?)?.toDouble() ?? 0.0,
        feelslikeC: (json["feelslike_c"] as num?)?.toDouble() ?? 0.0,
        condition: _Condition.fromJson(json["condition"]));
  }
  @override
  List<Object?> get props =>
      [lastUpdated, tempC, tempF, humidity, windKph, feelslikeC, condition];
}

class _Condition extends Equatable {
  final String text, icon;
  final int code;
  const _Condition(
      {required this.text, required this.icon, required this.code});
  factory _Condition.fromJson(Map<String, dynamic> json) {
    return _Condition(
        text: json["text"] ?? '',
        icon: json["icon"] != null
            ? (json["icon"].startsWith('//')
                ? 'https:${json["icon"]}'
                : json["icon"])
            : '',
        code: json["code"] as int? ?? -1);
  }
  @override
  List<Object?> get props => [text, icon, code];
}

class _Forecast extends Equatable {
  final List<_ForecastDay> forecastDay;
  const _Forecast({required this.forecastDay});
  factory _Forecast.fromJson(Map<String, dynamic> json) {
    var list = json["forecastday"] as List?;
    List<_ForecastDay> days =
        list?.map((e) => _ForecastDay.fromJson(e)).toList() ?? [];
    return _Forecast(forecastDay: days);
  }
  @override
  List<Object?> get props => [forecastDay];
}

class _ForecastDay extends Equatable {
  final String date;
  final _Day day;
  final _Astro astro;
  final List<_Hour> hour;
  const _ForecastDay(
      {required this.date,
      required this.day,
      required this.astro,
      required this.hour});
  factory _ForecastDay.fromJson(Map<String, dynamic> json) {
    var hourList = json['hour'] as List?;
    List<_Hour> hours = hourList?.map((e) => _Hour.fromJson(e)).toList() ?? [];
    return _ForecastDay(
        date: json["date"] ?? '',
        day: _Day.fromJson(json["day"] ?? {}),
        astro: _Astro.fromJson(json["astro"] ?? {}),
        hour: hours);
  }
  @override
  List<Object?> get props => [date, day, astro, hour];
}

class _Day extends Equatable {
  final double maxTempC, minTempC, avgTempC;
  final _Condition condition;
  const _Day(
      {required this.maxTempC,
      required this.minTempC,
      required this.avgTempC,
      required this.condition});
  factory _Day.fromJson(Map<String, dynamic> json) {
    return _Day(
        maxTempC: (json["maxtemp_c"] as num?)?.toDouble() ?? 0.0,
        minTempC: (json["mintemp_c"] as num?)?.toDouble() ?? 0.0,
        avgTempC: (json["avgtemp_c"] as num?)?.toDouble() ?? 0.0,
        condition: _Condition.fromJson(json["condition"] ?? {}));
  }
  @override
  List<Object?> get props => [maxTempC, minTempC, avgTempC, condition];
}

class _Astro extends Equatable {
  final String sunrise, sunset;
  const _Astro({required this.sunrise, required this.sunset});
  factory _Astro.fromJson(Map<String, dynamic> json) {
    return _Astro(sunrise: json["sunrise"] ?? '', sunset: json["sunset"] ?? '');
  }
  @override
  List<Object?> get props => [sunrise, sunset];
}

class _Hour extends Equatable {
  final int timeEpoch;
  final String time;
  final double tempC;
  final _Condition condition;
  final double chanceOfRain;
  const _Hour(
      {required this.timeEpoch,
      required this.time,
      required this.tempC,
      required this.condition,
      required this.chanceOfRain});
  factory _Hour.fromJson(Map<String, dynamic> json) {
    return _Hour(
        timeEpoch: json['time_epoch'] as int? ?? 0,
        time: json['time'] ?? '',
        tempC: (json['temp_c'] as num?)?.toDouble() ?? 0.0,
        condition: _Condition.fromJson(json['condition'] ?? {}),
        chanceOfRain: (json['chance_of_rain'] as num?)?.toDouble() ?? 0.0);
  }
  @override
  List<Object?> get props => [timeEpoch, time, tempC, condition, chanceOfRain];
}
