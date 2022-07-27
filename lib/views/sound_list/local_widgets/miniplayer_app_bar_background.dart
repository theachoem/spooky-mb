import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spooky/providers/mini_sound_player_provider.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/views/main/local_widgets/enhanced_weather_bg.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class MiniplayerAppBarBackground extends StatelessWidget {
  const MiniplayerAppBarBackground({
    Key? key,
    this.wave = 0.8,
  }) : super(key: key);

  final double wave;

  @override
  Widget build(BuildContext context) {
    return Consumer<MiniSoundPlayerProvider>(
      builder: (context, provider, child) {
        Color foregroundColor = Theme.of(context).appBarTheme.backgroundColor!;
        return AnimatedOpacity(
          duration: ConfigConstant.fadeDuration,
          opacity: provider.hasPlaying && Theme.of(context).brightness == Brightness.dark ? 1 : 0,
          child: Stack(
            children: [
              LayoutBuilder(
                builder: (context, constraint) {
                  return EnhancedWeatherBg(
                    weatherType: provider.weatherType,
                    width: constraint.maxWidth,
                    height: constraint.maxHeight,
                    debug: false,
                  );
                },
              ),
              Positioned.fill(
                child: WaveWidget(
                  backgroundColor: foregroundColor.withOpacity(0.3),
                  config: CustomConfig(
                    gradients: [
                      [foregroundColor.withOpacity(0.2), foregroundColor.withOpacity(0.6)],
                      [foregroundColor.withOpacity(0.3), foregroundColor.withOpacity(0.5)],
                      [foregroundColor.withOpacity(0.4), foregroundColor.withOpacity(0.4)],
                      [foregroundColor.withOpacity(0.5), foregroundColor.withOpacity(0.3)]
                    ],
                    durations: [35000, 19440, 10800, 6000],
                    heightPercentages: [0.0, 0.15, 0.10, 0.05].map((e) => e + wave).toList(),
                    gradientBegin: Alignment.bottomLeft,
                    gradientEnd: Alignment.topRight,
                  ),
                  waveAmplitude: 0,
                  size: const Size(
                    double.infinity,
                    double.infinity,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
