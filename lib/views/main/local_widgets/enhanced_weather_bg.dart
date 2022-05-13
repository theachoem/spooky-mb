import 'package:flutter/material.dart';
import 'package:flutter_weather_bg_null_safety/bg/weather_color_bg.dart';
import 'package:flutter_weather_bg_null_safety/bg/weather_rain_snow_bg.dart';
import 'package:flutter_weather_bg_null_safety/bg/weather_thunder_bg.dart';
import 'package:flutter_weather_bg_null_safety/flutter_weather_bg.dart';
import 'package:flutter_weather_bg_null_safety/utils/print_utils.dart';

/// 最核心的类，集合背景&雷&雨雪&晴晚&流星效果
/// 1. 支持动态切换大小
/// 2. 支持渐变过度
class EnhancedWeatherBg extends StatefulWidget {
  final WeatherType weatherType;
  final double width;
  final double height;

  EnhancedWeatherBg({
    Key? key,
    required this.weatherType,
    required this.width,
    required this.height,
    bool debug = true,
  }) : super(key: key) {
    debugging = debug;
  }

  @override
  EnhancedWeatherBgState createState() => EnhancedWeatherBgState();
}

class EnhancedWeatherBgState extends State<EnhancedWeatherBg> with SingleTickerProviderStateMixin {
  WeatherType? _oldWeatherType;
  bool needChange = false;
  var state = CrossFadeState.showSecond;

  @override
  void didUpdateWidget(EnhancedWeatherBg oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.weatherType != oldWidget.weatherType) {
      // 如果类别发生改变，需要 start 渐变动画
      _oldWeatherType = oldWidget.weatherType;
      needChange = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    EnhanceWeatherItemBg? oldBgWidget;
    if (_oldWeatherType != null) {
      oldBgWidget = EnhanceWeatherItemBg(
        weatherType: _oldWeatherType!,
        width: widget.width,
        height: widget.height,
      );
    }
    var currentBgWidget = EnhanceWeatherItemBg(
      weatherType: widget.weatherType,
      width: widget.width,
      height: widget.height,
    );
    oldBgWidget ??= currentBgWidget;
    var firstWidget = currentBgWidget;
    var secondWidget = currentBgWidget;
    if (needChange) {
      if (state == CrossFadeState.showSecond) {
        state = CrossFadeState.showFirst;
        firstWidget = currentBgWidget;
        secondWidget = oldBgWidget;
      } else {
        state = CrossFadeState.showSecond;
        secondWidget = currentBgWidget;
        firstWidget = oldBgWidget;
      }
    }
    needChange = false;
    return SizeInherited(
      size: Size(widget.width, widget.height),
      child: AnimatedCrossFade(
        firstChild: firstWidget,
        secondChild: secondWidget,
        duration: const Duration(milliseconds: 300),
        crossFadeState: state,
      ),
    );
  }
}

class EnhanceWeatherItemBg extends StatelessWidget {
  final WeatherType weatherType;
  final double width, height;

  const EnhanceWeatherItemBg({
    Key? key,
    required this.weatherType,
    required this.width,
    required this.height,
  }) : super(key: key);

  /// 构建晴晚背景效果
  // Widget _buildNightStarBg() {
  //   if (weatherType == WeatherType.sunnyNight) {
  //     return WeatherNightStarBg(
  //       weatherType: weatherType,
  //     );
  //   }
  //   return Container();
  // }

  /// 构建雷暴效果
  Widget _buildThunderBg() {
    if (weatherType == WeatherType.thunder) {
      return WeatherThunderBg(
        weatherType: weatherType,
      );
    }
    return Container();
  }

  /// 构建雨雪背景效果
  Widget _buildRainSnowBg() {
    if (WeatherUtil.isSnowRain(weatherType)) {
      return WeatherRainSnowBg(
        weatherType: weatherType,
        viewWidth: width,
        viewHeight: height,
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ClipRect(
        child: Stack(
          children: [
            Opacity(
              opacity: 0.25,
              child: WeatherColorBg(
                weatherType: weatherType,
              ),
            ),
            // WeatherCloudBg(
            //   weatherType: weatherType,
            // ),
            _buildRainSnowBg(),
            _buildThunderBg(),
            // Opacity(
            //   opacity: 0.5,
            //   child: _buildNightStarBg(),
            // ),
          ],
        ),
      ),
    );
  }
}
