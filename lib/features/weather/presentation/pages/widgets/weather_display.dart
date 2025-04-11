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
            style: theme.textTheme.headlineSmall?.copyWith(
              fontFamily: AppConstants.defaultFontFamily,
              color: theme.colorScheme.onBackground,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.smallPadding / 2),
          Text(
            weather.location.localtime,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onBackground.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: AppConstants.mediumPadding),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                getWeatherIcon(weather.current.condition.code),
                size: 80,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: AppConstants.defaultPadding),
              Text(
                "${weather.current.tempC.toStringAsFixed(0)}°C",
                style: theme.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onBackground,
                ),
              ),
            ],
          ),
          Text(
            weather.current.condition.text,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onBackground.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.largePadding),
          Card(
            elevation: AppConstants.elevationLow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
            ),
            color: theme.colorScheme.surface,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppConstants.defaultPadding,
                horizontal: AppConstants.smallPadding,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildInfoColumn(
                    context: context,
                    icon: Icons.thermostat_outlined,
                    label: localizations.feelsLike,
                    value: "${weather.current.tempF.toStringAsFixed(0)}°",
                  ),
                  _buildInfoColumn(
                    context: context,
                    icon: Icons.water_drop_outlined,
                    label: localizations.humidity,
                    value: "${weather.current.humidity}%",
                  ),
                  _buildInfoColumn(
                    context: context,
                    icon: Icons.air,
                    label: localizations.wind,
                    value: "${weather.current.windKph.toStringAsFixed(1)} km/h",
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppConstants.largePadding),
          if (weather.forecast.forecastDay.isNotEmpty) ...[
            Text(
              localizations.forecast,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            _buildForecastList(context, weather.forecast.forecastDay),
          ]
        ],
      ),
    );
  }

  Widget _buildInfoColumn({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Icon(
          icon,
          color: theme.colorScheme.primary.withOpacity(0.8),
          size: 24,
        ),
        const SizedBox(height: AppConstants.smallPadding / 2),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onBackground.withOpacity(0.7),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: theme.colorScheme.onBackground,
          ),
        ),
      ],
    );
  }

  Widget _buildForecastList(BuildContext context, List<ForecastDay> forecastDays) {
    final theme = Theme.of(context);

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
              left: index == 0 ? AppConstants.smallPadding : 0,
            ),
            padding: const EdgeInsets.symmetric(
              vertical: AppConstants.smallPadding,
              horizontal: 4,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('d MMM', Localizations.localeOf(context).languageCode)
                      .format(DateTime.parse(dayForecast.date)),
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.wb_cloudy_outlined,
                  size: 28,
                  color: theme.iconTheme.color?.withOpacity(0.6),
                ),
                const Spacer(),
                Text(
                  "${dayForecast.day.maxTempC.toStringAsFixed(0)}° / ${dayForecast.day.minTempC.toStringAsFixed(0)}°",
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
