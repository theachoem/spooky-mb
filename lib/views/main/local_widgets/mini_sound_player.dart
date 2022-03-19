import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:provider/provider.dart';
import 'package:spooky/core/models/sound_model.dart';
import 'package:spooky/providers/mini_sound_player_provider.dart';
import 'package:spooky/providers/user_provider.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/utils/constants/config_constant.dart';

class MiniSoundPlayer extends StatelessWidget {
  const MiniSoundPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    if (userProvider.relaxSoundPlayer) {
      return _MiniSoundPlayer();
    } else {
      return SizedBox.shrink();
    }
  }
}

class _MiniSoundPlayer extends StatelessWidget {
  const _MiniSoundPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MiniSoundPlayerProvider provider = Provider.of<MiniSoundPlayerProvider>(context);
    SoundModel? sound = provider.soundsList?.sounds.first;
    return Miniplayer(
      valueNotifier: provider.playerExpandProgress,
      minHeight: provider.playerMinHeight,
      maxHeight: provider.playerMaxHeight,
      controller: provider.controller,
      elevation: 4,
      curve: Curves.easeOut,
      builder: (height, percentage) {
        final bool miniplayer = percentage < provider.miniplayerPercentageDeclaration;
        final double width = MediaQuery.of(context).size.width;
        final maxImgSize = width * 0.4;
        final img = AspectRatio(
          aspectRatio: 1,
          child: AnimatedContainer(
            duration: ConfigConstant.fadeDuration,
            decoration: BoxDecoration(
              color: M3Color.of(context).primary,
              borderRadius: BorderRadius.circular(
                lerpDouble(0.0, ConfigConstant.radius2, percentage)!,
              ),
            ),
            child: Icon(
              Icons.music_note,
              color: M3Color.of(context).onPrimary,
            ),
          ),
        );

        final text = Text(provider.soundsList?.sounds.first.soundName ?? "", maxLines: 1);
        final buttonPlay = IconButton(icon: Icon(Icons.pause), onPressed: provider.onTap);

        final progressIndicator = LinearProgressIndicator(value: 0.3);

        if (!miniplayer) {
          var percentageExpandedPlayer = provider.percentageFromValueInRange(
            min: provider.playerMaxHeight * provider.miniplayerPercentageDeclaration + provider.playerMinHeight,
            max: provider.playerMaxHeight,
            value: height,
          );

          if (percentageExpandedPlayer < 0) percentageExpandedPlayer = 0;
          final paddingVertical = provider.valueFromPercentageInRange(
            min: 0,
            max: 10,
            percentage: percentageExpandedPlayer,
          );

          final double heightWithoutPadding = height - paddingVertical * 2;
          final double imageSize = heightWithoutPadding > maxImgSize ? maxImgSize : heightWithoutPadding;
          final paddingLeft = provider.valueFromPercentageInRange(
                min: 0,
                max: width - imageSize,
                percentage: percentageExpandedPlayer,
              ) /
              2;

          final buttonSkipForward = IconButton(
            icon: Icon(Icons.forward_30),
            iconSize: 33,
            onPressed: provider.onTap,
          );

          final buttonSkipBackwards = IconButton(
            icon: Icon(Icons.replay_10),
            iconSize: 33,
            onPressed: provider.onTap,
          );

          final buttonPlayExpanded = IconButton(
            icon: Icon(Icons.pause_circle_filled),
            iconSize: 50,
            onPressed: provider.onTap,
          );

          return Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: paddingLeft, top: paddingVertical, bottom: paddingVertical),
                  child: SizedBox(
                    height: imageSize,
                    child: img,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 33),
                  child: Opacity(
                    opacity: percentageExpandedPlayer,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(child: text),
                        Flexible(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [buttonSkipBackwards, buttonPlayExpanded, buttonSkipForward],
                          ),
                        ),
                        Flexible(child: progressIndicator),
                        Container(),
                        Container(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        //Miniplayer
        final percentageMiniplayer = provider.percentageFromValueInRange(
          min: provider.playerMinHeight,
          max: provider.playerMaxHeight * provider.miniplayerPercentageDeclaration + provider.playerMinHeight,
          value: height,
        );

        final elementOpacity = 1 - 1 * percentageMiniplayer;
        final progressIndicatorHeight = 4 - 4 * percentageMiniplayer;

        return Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: maxImgSize),
                    child: img,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Opacity(
                        opacity: elementOpacity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              sound?.fileName ?? "Unknown",
                              style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 16),
                              maxLines: 1,
                            ),
                            Text(
                              sound?.fileSize.toString() ?? "0 bytes",
                              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                    color: Theme.of(context).textTheme.bodyText2!.color!.withOpacity(0.55),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.fullscreen),
                    onPressed: () {
                      provider.controller.animateToHeight(state: PanelState.MAX);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 3),
                    child: Opacity(
                      opacity: elementOpacity,
                      child: buttonPlay,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: progressIndicatorHeight,
              child: Opacity(
                opacity: elementOpacity,
                child: progressIndicator,
              ),
            ),
          ],
        );
      },
    );
  }
}
