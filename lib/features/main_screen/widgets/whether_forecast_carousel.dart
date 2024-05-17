import 'package:flutter/material.dart';
import 'package:weather_nearby/core/utils/scroll_behavior.dart';
import 'package:weather_nearby/features/main_screen/data/models/response/whether/weather_data.dart';
import 'package:weather_nearby/features/main_screen/widgets/weather_small_view.dart';

class WeatherForecastCarousel extends StatefulWidget {
  final List<WeatherData> weathersData;
  final void Function(WeatherData current)? onCurrentWeatherDataChanged;

  const WeatherForecastCarousel({
    super.key,
    required this.weathersData,
    this.onCurrentWeatherDataChanged,
  });

  @override
  State<WeatherForecastCarousel> createState() => _WeatherForecastCarouselState();
}

class _WeatherForecastCarouselState extends State<WeatherForecastCarousel> {
  final _pageViewController = PageController(viewportFraction: 0.2);
  var _pageIndex = 0;

  @override
  Widget build(BuildContext context) => PageView.builder(
        controller: _pageViewController,
        itemCount: widget.weathersData.length,
        pageSnapping: false,
        scrollBehavior: CustomScrollBehavior(),
        onPageChanged: _onUpdatePage,
        itemBuilder: (context, index) => ColoredBox(
          color: index == _pageIndex ? Colors.lime : Colors.transparent,
          child: InkWell(
            onTap: () => _pageViewController.animateToPage(
              index,
              duration: Duration(
                milliseconds: 400,
              ),
              curve: Curves.linear,
            ),
            child: WeatherSmallView(
              weatherData: widget.weathersData[index],
            ),
          ),
        ),
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
