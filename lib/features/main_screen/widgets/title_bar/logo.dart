import 'package:flutter/material.dart';
import 'package:weather_nearby/core/app_colors.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) => const AspectRatio(
    aspectRatio: 1,
    child: FittedBox(
      child: Text.rich(
            TextSpan(
              text: 'Weather\n',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
                fontSize: 40,
                fontStyle: FontStyle.italic,
                height: 0.6,
              ),
              children: [
                TextSpan(
                  text: 'Nearby',
                  style: TextStyle(
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
            softWrap: false,
            maxLines: 2,
          ),
    ),
  );
}
