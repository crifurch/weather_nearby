import 'package:flutter/material.dart';
import 'package:weather_nearby/core/app_colors.dart';

class CardDecoration extends StatelessWidget {
  final Widget child;
  final bool topLeftCorner;
  final bool topRightCorner;
  final bool bottomLeftCorner;
  final bool bottomRightCorner;
  final Color backgroundColor;
  final bool dropShadow;

  const CardDecoration({
    super.key,
    required this.child,
    this.topLeftCorner = true,
    this.topRightCorner = true,
    this.bottomLeftCorner = true,
    this.bottomRightCorner = true,
    this.backgroundColor = AppColors.main,
    this.dropShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    const radius = Radius.circular(8);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.only(
          bottomLeft: bottomLeftCorner ? radius : Radius.zero,
          bottomRight: bottomRightCorner ? radius : Radius.zero,
          topLeft: topLeftCorner ? radius : Radius.zero,
          topRight: topRightCorner ? radius : Radius.zero,
        ),
        boxShadow: [
          if (dropShadow)
            BoxShadow(
              color: Colors.black12.withAlpha(20),
              offset: const Offset(2, 2),
              spreadRadius: 1,
              blurRadius: 8,
            ),
        ],
      ),
      child: child,
    );
  }
}
