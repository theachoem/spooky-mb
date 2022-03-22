import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spooky/providers/mini_sound_player_provider.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/views/main/local_widgets/mini_sound_player.dart';
import 'package:spooky/widgets/sp_cross_fade.dart';

class MiniPlayerScaffold extends StatelessWidget {
  const MiniPlayerScaffold({
    Key? key,
    required this.body,
    required this.shouldShowBottomNavNotifier,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.appBar,
    this.extendBody = false,
  }) : super(key: key);

  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Widget body;
  final bool extendBody;
  final PreferredSizeWidget? appBar;
  final ValueNotifier<bool> shouldShowBottomNavNotifier;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      extendBody: extendBody,
      floatingActionButton: floatingActionButton,
      body: Stack(
        children: [
          body,
          buildBarrierColor(context),
        ],
      ),
      bottomNavigationBar: Wrap(
        children: [
          Hero(
            tag: ValueKey(runtimeType),
            child: const MiniSoundPlayer(),
          ),
          const Divider(height: 0.0),
          buildBottomSafeHeight(context),
          if (bottomNavigationBar != null) bottomNavigationBar!,
        ],
      ),
    );
  }

  Widget buildBarrierColor(BuildContext context) {
    MiniSoundPlayerProvider miniSoundPlayerProvider = context.read<MiniSoundPlayerProvider>();
    return ValueListenableBuilder<double>(
      valueListenable: miniSoundPlayerProvider.playerExpandProgressNotifier,
      builder: (context, percentage, child) {
        double offset = miniSoundPlayerProvider.offset(percentage);
        return Positioned.fill(
          child: IgnorePointer(
            ignoring: offset == 0.0,
            child: GestureDetector(
              onTap: () {
                miniSoundPlayerProvider.controller.animateToHeight(height: miniSoundPlayerProvider.playerMinHeight);
              },
              child: Opacity(
                opacity: offset,
                child: Container(color: Colors.black54),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildBottomSafeHeight(BuildContext context) {
    return Consumer<MiniSoundPlayerProvider>(
      child: ValueListenableBuilder<bool>(
        valueListenable: shouldShowBottomNavNotifier,
        builder: (context, shownBottomNav, chil) {
          return AnimatedContainer(
            height: shownBottomNav ? 0.0 : MediaQuery.of(context).padding.bottom,
            color: Theme.of(context).appBarTheme.backgroundColor,
            duration: ConfigConstant.duration,
            curve: Curves.ease,
          );
        },
      ),
      builder: (context, provider, child) {
        return SpCrossFade(
          showFirst: provider.currentSounds.isNotEmpty,
          firstChild: child!,
          secondChild: const SizedBox(width: double.infinity),
        );
      },
    );
  }
}
