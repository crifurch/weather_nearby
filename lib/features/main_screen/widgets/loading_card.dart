import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:weather_nearby/core/app_colors.dart';
import 'package:weather_nearby/core/localization/translation_service.dart';
import 'package:weather_nearby/core/localization/translations_keys.dart';
import 'package:weather_nearby/core/widgets/decoration/card_decoration.dart';
import 'package:weather_nearby/core/widgets/layout/limited_aspect_ratio.dart';
import 'package:weather_nearby/features/data/models/requesting_location.dart';

class LoadingCard extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onReloadClick;
  final VoidCallback? onChangeLocationClick;
  final RequestingLocation? location;

  const LoadingCard({
    super.key,
    this.isLoading = false,
    this.onReloadClick,
    this.onChangeLocationClick,
    this.location,
  });

  @override
  Widget build(BuildContext context) => CardDecoration(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: LimitedAspectRatio(
            aspectRatio: 2,
            minWidth: 200,
            minHeight: 200,
            maxWidth: 1300,
            maxHeight: 600,
            child: Center(
              child: isLoading
                  ? const CircularProgressIndicator()
                  : Padding(
                    padding: const EdgeInsets.all(10),
                    child: FittedBox(
                        child: Text.rich(
                          TextSpan(
                            text: '${context.translate(TranslationsKeys.loadWeatherError, location?.location??'')}\n',
                            children: [
                              TextSpan(
                                text: '${context.translate(TranslationsKeys.loadWeatherSolution1)}\n',
                                mouseCursor: SystemMouseCursors.click,
                                recognizer: TapGestureRecognizer()..onTap = onReloadClick,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textAction,
                                  decorationColor: AppColors.textAction,
                                  decorationThickness: 3,
                                  decoration: TextDecoration.underline,
                                  fontSize: 18,
                                ),
                              ),
                              TextSpan(
                                text: '${context.translate(TranslationsKeys.or)}\n',
                              ),
                              TextSpan(
                                text: '${context.translate(TranslationsKeys.loadWeatherSolution2)}\n',
                                mouseCursor: SystemMouseCursors.click,
                                recognizer: TapGestureRecognizer()..onTap = onChangeLocationClick,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textAction,
                                  decorationColor: AppColors.textAction,
                                  decorationThickness: 3,
                                  decoration: TextDecoration.underline,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                          ),
                        ),
                      ),
                  ),
            ),
          ),
        ),
      );
}
