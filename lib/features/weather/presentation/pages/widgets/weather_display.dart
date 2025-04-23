import 'package:farmersfriendapp/core/models/weather.dart';
import 'package:farmersfriendapp/core/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class WeatherDisplay extends StatelessWidget {
  final Weather weather;

  const WeatherDisplay({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    IconData getWeatherIcon(int conditionCode) {
      if (conditionCode == 1000) return Icons.wb_sunny_outlined;
      if (conditionCode == 1003) return Icons.wb_cloudy_outlined;
      if (conditionCode >= 1180 && conditionCode <= 1201) return Icons.grain;
      return Icons.thermostat;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            weather.location.country,
            style: theme.textTheme.headlineSmall
                ?.copyWith(fontFamily: AppConstants.defaultFontFamily),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.smallPadding / 2),
          Text(
            weather.location.localtime,
            style: theme.textTheme.bodySmall
                ?.copyWith(color: AppConstants.textColorSecondary),
          ),
          const SizedBox(height: AppConstants.mediumPadding),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                getWeatherIcon(weather.current.condition.code),
                size: 80,
                color: theme.primaryColor,
              ),
              const SizedBox(width: AppConstants.defaultPadding),
              Text(
                "${weather.current.tempC.toStringAsFixed(0)}°C",
                style: theme.textTheme.displayMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Text(
            weather.current.condition.text,
            style: theme.textTheme.titleMedium
                ?.copyWith(color: AppConstants.textColorSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.largePadding),
          Card(
            elevation: AppConstants.elevationLow,
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(AppConstants.borderRadiusMedium)),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: AppConstants.defaultPadding,
                  horizontal: AppConstants.smallPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildInfoColumn(
                      icon: Icons.thermostat_outlined,
                      label: localizations.feelsLike,
                      value: "${weather.current.tempF.toStringAsFixed(0)}°"),
                  _buildInfoColumn(
                      icon: Icons.water_drop_outlined,
                      label: localizations.humidity,
                      value: "${weather.current.humidity}%"),
                  _buildInfoColumn(
                      icon: Icons.air,
                      label: localizations.wind,
                      value:
                          "${weather.current.windKph.toStringAsFixed(1)} km/h"),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppConstants.largePadding),
          if (weather.forecast.forecastDay.isNotEmpty) ...[
            Text(localizations.forecast, style: theme.textTheme.headlineSmall),
            const SizedBox(height: AppConstants.defaultPadding),
            _buildForecastList(context, weather.forecast.forecastDay),
          ]
        ],
      ),
    );
  }

  Widget _buildInfoColumn(
      {required IconData icon, required String label, required String value}) {
    return Column(
      children: [
        Icon(icon, color: AppConstants.primaryColor.withOpacity(0.8), size: 24),
        const SizedBox(height: AppConstants.smallPadding / 2),
        Text(label,
            style: TextStyle(
                color: AppConstants.textColorSecondary,
                fontSize: 12,
                fontFamily: AppConstants.defaultFontFamily)),
        const SizedBox(height: 2),
        Text(value,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                fontFamily: AppConstants.defaultFontFamily)),
      ],
    );
  }

  Widget _buildForecastList(
      BuildContext context, List<ForecastDay> forecastDays) {
    return SizedBox(
      height: 130,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: forecastDays.length,
          itemBuilder: (context, index) {
            final dayForecast = forecastDays[index];
            return Container(
              width: 90,
              margin: EdgeInsets.only(
                  right: AppConstants.smallPadding,
                  left: index == 0 ? AppConstants.smallPadding : 0),
              padding: const EdgeInsets.symmetric(
                  vertical: AppConstants.smallPadding, horizontal: 4),
              decoration: BoxDecoration(
                  color: AppConstants.whiteColor,
                  borderRadius:
                      BorderRadius.circular(AppConstants.borderRadiusMedium),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: Offset(0, 2))
                  ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      DateFormat('d MMM',
                              Localizations.localeOf(context).languageCode)
                          .format(DateTime.parse(dayForecast.date)),
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Icon(
                    Icons.wb_cloudy_outlined,
                    size: 28,
                    color: Colors.grey[600],
                  ),
                  const Spacer(),
                  Text(
                    "${dayForecast.day.maxTempC.toStringAsFixed(0)}° / ${dayForecast.day.minTempC.toStringAsFixed(0)}°",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
