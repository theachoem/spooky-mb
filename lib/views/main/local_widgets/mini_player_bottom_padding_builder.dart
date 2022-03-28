import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spooky/providers/mini_sound_player_provider.dart';

class MiniPlayerBottomPaddingBuilder extends StatelessWidget {
  const MiniPlayerBottomPaddingBuilder({
    Key? key,
    required this.builder,
    required this.shouldShowBottomNavNotifier,
    this.child,
  }) : super(key: key);

  final Widget Function(
    BuildContext context,
    double offset,
    double bottomHeight,
    Widget? child,
  ) builder;

  final ValueNotifier<bool> shouldShowBottomNavNotifier;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    MiniSoundPlayerProvider providerReader = context.read<MiniSoundPlayerProvider>();
    return ValueListenableBuilder<double>(
      valueListenable: providerReader.playerExpandProgressNotifier,
      child: child,
      builder: (context, percentage, child) {
        return ValueListenableBuilder<bool>(
          valueListenable: shouldShowBottomNavNotifier,
          builder: (context, shownBottomNav, _) {
            double height = shownBottomNav ? 0.0 : MediaQuery.of(context).padding.bottom;
            double offset = providerReader.offset(percentage);
            return builder(
              context,
              height,
              offset,
              child,
            );
          },
        );
      },
    );
  }
}
