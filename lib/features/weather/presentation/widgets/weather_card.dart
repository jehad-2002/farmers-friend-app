import 'package:flutter/material.dart';
import '/core/utils/app_constants.dart';

class WeatherCard extends StatelessWidget {
  const WeatherCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: AppConstants.elevationMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
      ),
      color: theme.colorScheme.surface.withOpacity(0.1), // Use theme's surface color
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today\'s Weather',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface, // Use theme's onSurface color
              ),
            ),
            const SizedBox(height: AppConstants.smallPadding),
            Row(
              children: [
                Icon(
                  Icons.wb_sunny_outlined,
                  color: theme.colorScheme.primary, // Use theme's primary color
                  size: 40,
                ),
                const SizedBox(width: AppConstants.defaultPadding),
                Text(
                  '25°C, Sunny',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface, // Use theme's onSurface color
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}