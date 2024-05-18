import 'package:flutter/material.dart';
import 'package:weather_nearby/core/app_colors.dart';
import 'package:weather_nearby/core/utils/scroll_behavior.dart';
import 'package:weather_nearby/core/widgets/decoration/card_decoration.dart';
import 'package:weather_nearby/features/main_screen/data/models/response/whether/weather_data.dart';
import 'package:weather_nearby/features/main_screen/widgets/weather/weather_small_view.dart';

class WeatherForecastCarousel extends StatefulWidget {
  final List<WeatherData> weathersData;
  final WeatherData? currentWeatherData;
  final void Function(WeatherData current)? onCurrentWeatherDataChanged;

  const WeatherForecastCarousel({
    super.key,
    required this.weathersData,
    this.currentWeatherData,
    this.onCurrentWeatherDataChanged,
  });

  @override
  State<WeatherForecastCarousel> createState() => _WeatherForecastCarouselState();
}

class _WeatherForecastCarouselState extends State<WeatherForecastCarousel> {
  final _pageViewController = PageController(viewportFraction: 0.25);
  var _pageIndex = 0;

  @override
  Widget build(BuildContext context) => PageView.builder(
        controller: _pageViewController,
        itemCount: widget.weathersData.length,
        pageSnapping: false,
        scrollBehavior: CustomScrollBehavior(),
        onPageChanged: _onUpdatePage,
        itemBuilder: (context, index) {
          final child = Padding(
            padding: const EdgeInsets.all(8.0),
            child: WeatherSmallView(
              weatherData: widget.weathersData[index],
              isCurrent: widget.weathersData[index] == widget.currentWeatherData,
            ),
          );
          if (index == _pageIndex) {
            return CardDecoration(
              topLeftCorner: false,
              topRightCorner: false,
              dropShadow: false,
              child: child,
            );
          }
          return CardDecoration(
            topRightCorner: false,
            topLeftCorner: false,
            dropShadow: false,
            child: CardDecoration(
              topRightCorner: index == _pageIndex - 1,
              topLeftCorner: index == _pageIndex + 1,
              bottomRightCorner: false,
              bottomLeftCorner: false,
              dropShadow: false,
              backgroundColor: AppColors.background,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CardDecoration(
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _pageViewController.animateToPage(
                        index,
                        duration: Duration(
                          //do smooth animation depends on "distance" between target an current page
                          milliseconds: (200 * (index - (_pageViewController.page ?? index)).abs()).toInt(),
                        ),
                        curve: Curves.linear,
                      ),
                      child: child,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );

  @override
  void didUpdateWidget(covariant WeatherForecastCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (_pageViewController.hasClients) {
        _onUpdatePage(_pageViewController.page!.toInt());
      }
    });
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    super.dispose();
  }

  void _onUpdatePage(int index) {
    setState(() {
      _pageIndex = index;
    });
    if (widget.weathersData.isNotEmpty) {
      widget.onCurrentWeatherDataChanged?.call(widget.weathersData[index]);
    }
  }
}
