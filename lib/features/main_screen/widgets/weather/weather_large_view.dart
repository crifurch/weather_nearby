import 'dart:math';

import 'package:flutter/material.dart';
import 'package:weather_nearby/core/app_colors.dart';
import 'package:weather_nearby/core/localization/translation_service.dart';
import 'package:weather_nearby/core/localization/translations_keys.dart';
import 'package:weather_nearby/core/utils/temperature_utils.dart';
import 'package:weather_nearby/core/widgets/every_second_builder.dart';
import 'package:weather_nearby/core/widgets/layout/limited_aspect_ratio.dart';
import 'package:weather_nearby/core/widgets/simple/basic_text.dart';
import 'package:weather_nearby/features/main_screen/data/models/response/weather/weather_data.dart';

class WeatherLargeView extends StatelessWidget {
  final WeatherData weatherData;
  final bool isCurrent;
  final WeatherAdditionalDetails? additionalDetails;

  const WeatherLargeView({
    super.key,
    required this.weatherData,
    this.isCurrent = false,
    this.additionalDetails,
  });

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/back.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BasicText(
              isCurrent
                  ? '${context.dateFormatter.userFriendlyShort.format(weatherData.dateTime.toLocal())}, '
                      '${context.translate(TranslationsKeys.now)}'
                  : context.dateFormatter.userFriendly.format(weatherData.dateTime.toLocal()),
              fontWeight: FontWeight.w600,
              fontSize: 15,
              textColor: AppColors.textSecondary,
            ),
            const SizedBox(height: 5),
            if (additionalDetails?.cityName != null ||
                additionalDetails?.lat != null ||
                additionalDetails?.lon != null) ...[
              const Spacer(),
              if (additionalDetails?.cityName != null)
                BasicText(
                  additionalDetails!.cityName!,
                  fontWeight: FontWeight.w700,
                  textScaleFactor: 1.5,
                  textColor: AppColors.textSecondary,
                ),
              const SizedBox(height: 2),
              if (additionalDetails?.lat != null && additionalDetails?.lon != null)
                BasicText(
                  '${additionalDetails?.lat} : ${additionalDetails?.lon}',
                  fontWeight: FontWeight.w100,
                  textColor: AppColors.textSecondary,
                ),
              const SizedBox(height: 5),
            ],
            if (additionalDetails?.lastUpdateUTC != null)
              EverySecondBuilder(
                build: () => BasicText(
                  context.translate(
                    TranslationsKeys.shortTimeLastUpdated,
                    _formatTimeSince(
                      context,
                      additionalDetails!.lastUpdateUTC!,
                    ),
                  ),
                  fontWeight: FontWeight.w100,
                  textColor: AppColors.textSecondary,
                ),
              ),
            const Spacer(flex: 4),
            BasicText(
              _tempToString(weatherData.weatherValues.temp),
              fontWeight: FontWeight.w700,
              textScaleFactor: 3.5,
              textColor: AppColors.textSecondary,
            ),
            const Spacer(flex: 4),
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.grey[400]!.withOpacity(0.4),
                borderRadius: const BorderRadius.all(Radius.circular(5)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 5,
                ),
                child: BasicText(
                  context.translate(TranslationsKeys.feelLike, _tempToString(weatherData.weatherValues.tempFeelsLike)),
                  fontSize: 12,
                  textColor: AppColors.textSecondary,
                ),
              ),
            ),
            const Spacer(),
            ColoredBox(
              color: AppColors.textPrimary.withAlpha(20),
              child: LimitedAspectRatio(
                aspectRatio: 5,
                maxHeight: 150,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2),
                      child: _WeatherValueView(
                        title: context.translate(TranslationsKeys.weatherValueWindLabel),
                        value: weatherData.windValues.speed.round().toString(),
                        measurements: context.translate(TranslationsKeys.weatherValueWindMeasurements),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2),
                      child: _WeatherValueView(
                        title: context.translate(TranslationsKeys.weatherValueHumidityLabel),
                        value: weatherData.weatherValues.humidity.round().toString(),
                        measurements: context.translate(TranslationsKeys.weatherValueHumidityMeasurements),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2),
                      child: _WeatherValueView(
                        title: context.translate(TranslationsKeys.weatherValuePressureLabel),
                        value: weatherData.weatherValues.pressure.round().toString(),
                        measurements: context.translate(TranslationsKeys.weatherValuePressureMeasurements),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  String _tempToString(num value) => '${value > 0 ? '+' : ''}'
      '${convertToCelsius(value.toDouble()).round()}';

  String _formatTimeSince(BuildContext context, DateTime dateTime) => '${_formatDiffToBiggest(context, dateTime)} '
      '${context.translate(TranslationsKeys.shortTimeAgo)}';

  String _formatDiffToBiggest(BuildContext context, DateTime dateTime) {
    final difference = DateTime.timestamp().difference(dateTime.toUtc());
    if (difference.inDays > 0) {
      return context.translate(TranslationsKeys.shortTimeDay, difference.inDays);
    }
    if (difference.inHours > 0) {
      return context.translate(TranslationsKeys.shortTimeHour, difference.inHours);
    }
    if (difference.inMinutes > 0) {
      return context.translate(TranslationsKeys.shortTimeMinute, difference.inMinutes);
    }
    return context.translate(TranslationsKeys.shortTimeSeconds, max(0, difference.inSeconds));
  }
}

class _WeatherValueView extends StatelessWidget {
  final String title;
  final String value;
  final String measurements;

  const _WeatherValueView({
    required this.title,
    required this.value,
    required this.measurements,
  });

  @override
  Widget build(BuildContext context) => Column(
        children: [
          const Spacer(flex: 2),
          BasicText(
            title,
            fontSize: 14,
            textColor: AppColors.textSecondary,
          ),
          const Spacer(flex: 3),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              BasicText(
                value,
                textScaleFactor: 2,
                fontWeight: FontWeight.bold,
                textColor: AppColors.textSecondary,
              ),
              const SizedBox(width: 2),
              BasicText(
                measurements,
                fontSize: 12,
                textColor: AppColors.textSecondary,
              ),
            ],
          ),
          const Spacer(flex: 2),
        ],
      );
}

class WeatherAdditionalDetails {
  final DateTime? lastUpdateUTC;
  final DateTime? latsLocationUpdateUTC;
  final String? cityName;
  final double? lat;
  final double? lon;

  WeatherAdditionalDetails({
    this.lastUpdateUTC,
    this.latsLocationUpdateUTC,
    this.cityName,
    this.lat,
    this.lon,
  });
}
