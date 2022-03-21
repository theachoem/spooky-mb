import 'dart:math';
import 'dart:ui';
import 'package:flutter_weather_bg_null_safety/flutter_weather_bg.dart';
import 'package:flutter/material.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:provider/provider.dart';
import 'package:spooky/core/models/sound_model.dart';
import 'package:spooky/core/types/sound_type.dart';
import 'package:spooky/providers/mini_sound_player_provider.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/extensions/string_extension.dart';
import 'package:spooky/widgets/sp_animated_icon.dart';
import 'package:spooky/widgets/sp_cross_fade.dart';
import 'package:spooky/widgets/sp_icon_button.dart';

class MiniSoundPlayer extends StatelessWidget {
  const MiniSoundPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        return _MiniSoundPlayer(constraints: constraint);
      },
    );
  }
}

class _MiniSoundPlayer extends StatelessWidget {
  const _MiniSoundPlayer({
    Key? key,
    required this.constraints,
  }) : super(key: key);

  final BoxConstraints constraints;
  Color get foregroundColor => Colors.white;

  @override
  Widget build(BuildContext context) {
    MiniSoundPlayerProvider provider = Provider.of<MiniSoundPlayerProvider>(context);
    if (provider.currentSounds.isEmpty) return const SizedBox.shrink();
    return Miniplayer(
      valueNotifier: provider.playerExpandProgressNotifier,
      minHeight: provider.playerMinHeight,
      maxHeight: provider.playerMaxHeight,
      controller: provider.controller,
      elevation: 0.0,
      onDismissed: () => provider.onDismissed(),
      curve: Curves.easeOut,
      builder: (height, percentage) {
        double width = MediaQuery.of(context).size.width;
        double imageMarginRight = lerpDouble(width - provider.playerMinHeight, 0, percentage * 2.5)!;

        double percentageMiniplayer = provider.percentageFromValueInRange(
          min: provider.playerMinHeight,
          max: provider.playerMaxHeight * provider.miniplayerPercentageDeclaration + provider.playerMinHeight,
          value: height,
        );

        double percentageExpandedPlayer = provider.percentageFromValueInRange(
          min: provider.playerMaxHeight * provider.miniplayerPercentageDeclaration + provider.playerMinHeight,
          max: provider.playerMaxHeight,
          value: height,
        );

        percentageMiniplayer = max(0.0, min(1.0, percentageMiniplayer));
        percentageExpandedPlayer = max(0.0, min(1.0, percentageExpandedPlayer));

        return Wrap(
          children: [
            Stack(
              children: [
                buildCollapseContent(
                  provider: provider,
                  height: height,
                  percentage: percentage,
                  percentageMiniplayer: percentageMiniplayer,
                ),
                buildWeatherEffect(
                  imageMarginRight: imageMarginRight,
                  context: context,
                  width: width,
                  provider: provider,
                  percentage: percentage,
                  percentageExpandedPlayer: percentageExpandedPlayer,
                ),
                buildExpandedContent(
                  provider,
                  height,
                  percentage,
                  percentageExpandedPlayer,
                  context,
                ),
              ],
            )
          ],
        );
      },
    );
  }

  Widget buildWeatherEffect({
    required double imageMarginRight,
    required BuildContext context,
    required double width,
    required MiniSoundPlayerProvider provider,
    required double percentage,
    required double percentageExpandedPlayer,
  }) {
    return Container(
      margin: EdgeInsets.only(right: max(0, imageMarginRight)),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(color: M3Color.of(context).primary),
        child: Stack(
          children: [
            WeatherBg(
              weatherType: provider.weatherType,
              width: width,
              height: lerpDouble(
                provider.playerMinHeight,
                provider.playerMaxHeight,
                percentage,
              )!,
            ),
            buildMusicManager(
              percentage: percentage,
              provider: provider,
              context: context,
              percentageExpandedPlayer: percentageExpandedPlayer,
            ),
          ],
        ),
      ),
    );
  }

  /// previus, play/pause, next button
  Widget buildMusicManager({
    required double percentage,
    required BuildContext context,
    required MiniSoundPlayerProvider provider,
    required double percentageExpandedPlayer,
  }) {
    return Positioned.fill(
      child: Container(
        margin: EdgeInsets.only(top: lerpDouble(0, 36, percentage)!),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildOptionButton(
              iconData: Icons.keyboard_arrow_left,
              percentage: percentage,
              provider: provider,
              percentageExpandedPlayer: percentageExpandedPlayer,
              onTap: () {
                provider.playPreviousNext(context: context, previous: false);
              },
            ),
            buildExpandedPlayPauseButton(
              provider: provider,
              percentage: percentage,
            ),
            buildOptionButton(
              iconData: Icons.keyboard_arrow_right,
              percentage: percentage,
              provider: provider,
              percentageExpandedPlayer: percentageExpandedPlayer,
              onTap: () {
                provider.playPreviousNext(context: context, previous: true);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOptionButton({
    required IconData iconData,
    required double percentage,
    required MiniSoundPlayerProvider provider,
    required double percentageExpandedPlayer,
    required void Function() onTap,
  }) {
    return Visibility(
      visible: percentage == 1,
      child: TweenAnimationBuilder<int>(
        duration: ConfigConstant.fadeDuration,
        tween: IntTween(begin: 0, end: 100),
        builder: (context, value, child) {
          return Opacity(
            opacity: value / 100,
            child: SpIconButton(
              onPressed: onTap,
              icon: Icon(
                iconData,
                size: ConfigConstant.iconSize3,
                color: foregroundColor,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildCollapseContent({
    required MiniSoundPlayerProvider provider,
    required double height,
    required double percentage,
    required double percentageMiniplayer,
  }) {
    return Positioned.fill(
      right: 0.0,
      bottom: 0.0,
      child: Opacity(
        opacity: 1 - max(0.0, min(1.0, percentageMiniplayer)),
        child: IgnorePointer(
          ignoring: 1 - percentage < 0.5,
          child: Row(
            children: [
              Container(width: provider.playerMinHeight + 8.0),
              buildCollapseTile(provider),
              buildFullScreenButton(provider),
              Container(width: 8.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFullScreenButton(MiniSoundPlayerProvider provider) {
    return SpIconButton(
      icon: Icon(Icons.fullscreen),
      onPressed: () {
        provider.controller.animateToHeight(state: PanelState.MAX);
      },
    );
  }

  Widget buildCollapseTile(MiniSoundPlayerProvider provider) {
    return Expanded(
      child: AnimatedContainer(
        duration: ConfigConstant.fadeDuration,
        padding: const EdgeInsets.only(left: ConfigConstant.margin1),
        alignment: Alignment.centerLeft,
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(provider.soundTitle, maxLines: 1),
          subtitle: ValueListenableBuilder<bool>(
            valueListenable: provider.currentlyPlayingNotifier,
            builder: (context, listening, child) {
              return SpCrossFade(
                showFirst: listening,
                firstChild: Text("Listening", maxLines: 1),
                secondChild: Text("Pause", maxLines: 1),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildExpandedContent(
    MiniSoundPlayerProvider provider,
    double height,
    double percentage,
    double percentageExpandedPlayer,
    BuildContext context,
  ) {
    return Positioned.fill(
      child: IgnorePointer(
        ignoring: percentage < 0.5,
        child: Opacity(
          opacity: max(0.0, min(1.0, percentageExpandedPlayer)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                provider.soundTitle,
                maxLines: 1,
                style: M3TextTheme.of(context).titleMedium?.copyWith(color: foregroundColor),
              ),
              SizedBox(height: ConfigConstant.margin2),
              SizedBox(height: ConfigConstant.iconSize3)
            ],
          ),
        ),
      ),
    );
  }

  Widget buildExpandedPlayPauseButton({
    required MiniSoundPlayerProvider provider,
    required double percentage,
  }) {
    return ValueListenableBuilder<bool>(
      valueListenable: provider.currentlyPlayingNotifier,
      builder: (context, currentPlaying, child) {
        Color? color = Color.lerp(Colors.white, Colors.black, percentage);
        return Container(
          decoration: BoxDecoration(
            color: Color.lerp(Colors.white.withOpacity(0.0), Colors.white, percentage),
            shape: BoxShape.circle,
          ),
          child: SpIconButton(
            icon: SpAnimatedIcons(
              duration: ConfigConstant.duration * 1.5,
              showFirst: currentPlaying,
              firstChild: Icon(
                Icons.pause,
                size: ConfigConstant.iconSize2,
                color: color,
              ),
              secondChild: Icon(
                Icons.play_arrow,
                size: ConfigConstant.iconSize2,
                color: color,
              ),
            ),
            onPressed: () {
              provider.togglePlayPause();
            },
          ),
        );
      },
    );
  }
}
