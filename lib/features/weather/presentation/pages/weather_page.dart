import 'package:farmersfriendapp/core/presentation/widgets/error_indicator.dart';
import 'package:farmersfriendapp/core/presentation/widgets/loading_indicator.dart';
import 'package:farmersfriendapp/core/service_locator.dart';
import 'package:farmersfriendapp/core/utils/app_constants.dart';
import 'package:farmersfriendapp/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:farmersfriendapp/features/weather/presentation/bloc/weather_event.dart';
import 'package:farmersfriendapp/features/weather/presentation/bloc/weather_state.dart';
import 'package:farmersfriendapp/features/weather/presentation/pages/widgets/city_input_field.dart';
import 'package:farmersfriendapp/features/weather/presentation/pages/widgets/weather_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (context) => WeatherBloc(getWeather: sl.getWeather)
        ..add(const FetchWeatherForDefaultCity()),
      child: Scaffold(
        backgroundColor: AppConstants.backgroundColor,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: CityInputField(
                enabled: true,
                onCitySubmitted: (city) {
                  if (city.isNotEmpty) {
                    context.read<WeatherBloc>().add(WeatherRequested(city));
                  }
                },
              ),
            ),
            Expanded(
              child: BlocBuilder<WeatherBloc, WeatherState>(
                builder: (context, state) {
                  if (state is WeatherLoadInProgress) {
                    return const LoadingIndicator(isCentered: true);
                  } else if (state is WeatherLoadSuccess) {
                    return WeatherDisplay(weather: state.weather.weather);
                  } else if (state is WeatherLoadFailure) {
                    return ErrorIndicator(
                        message: state.message,
                        onRetry: () {
                          context
                              .read<WeatherBloc>()
                              .add(const FetchWeatherForDefaultCity());
                        });
                  } else {
                    return Center(
                        child: Padding(
                      padding: const EdgeInsets.all(AppConstants.largePadding),
                      child: Text(localizations.enterCityPrompt,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  color: AppConstants.textColorSecondary)),
                    ));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
