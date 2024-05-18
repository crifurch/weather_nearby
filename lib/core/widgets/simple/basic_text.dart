import 'package:flutter/material.dart';
import 'package:weather_nearby/core/app_colors.dart';

class BasicText extends StatelessWidget {
  final String text;
  final Color textColor;
  final double fontSize;
  final double textScaleFactor;
  final TextAlign textAlign;
  final FontWeight? fontWeight;

  const BasicText(
    this.text, {
    super.key,
    this.textColor = AppColors.textPrimary,
    this.fontSize = 11,
    this.textScaleFactor = 1,
    this.textAlign = TextAlign.start,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) => Text(
        text,
        textScaler: TextScaler.linear(textScaleFactor),
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
        textAlign: textAlign,
      );
}
