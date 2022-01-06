import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:spooky/initial_theme.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/ui/views/home/local_widgets/home_tab_bar.dart';
import 'package:spooky/ui/widgets/sp_icon_button.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/mixins/stateful_mixin.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeAppBar extends StatefulWidget {
  const HomeAppBar({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.tabLabels,
    required this.tabController,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final List<String> tabLabels;
  final TabController tabController;

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> with StatefulMixin {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      elevation: appBarTheme.elevation,
      pinned: true,
      floating: true,
      stretch: true,
      expandedHeight: kToolbarHeight + 48.0 + 32.0 + 16.0,
      bottom: HomeTabBar(
        height: 40,
        controller: widget.tabController,
        tabs: List.generate(
          widget.tabLabels.length,
          (index) => widget.tabLabels[index],
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        stretchModes: [
          StretchMode.zoomBackground,
        ],
        background: buildBackground(),
      ),
    );
  }

  Widget buildBackground() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.0, statusBarHeight + 24.0 + 4.0, 16.0, 0),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: textTheme.headline6?.copyWith(color: colorScheme.primary),
              ),
              ConfigConstant.sizedBoxH0,
              Text(
                widget.subtitle,
                style: textTheme.bodyText2?.copyWith(color: colorScheme.onSurface),
              ),
            ],
          ),
          buildThemeSwitcherButton()
        ],
      ),
    );
  }

  Widget buildThemeSwitcherButton() {
    return Positioned(
      right: 0,
      child: SpIconButton(
        icon: Icon(
          Icons.dark_mode,
          color: M3Color.of(context)?.primary,
        ),
        backgroundColor: M3Color.of(context)?.primaryContainer,
        onLongPress: () async {
          ThemeMode? result = await showConfirmationDialog(
            context: context,
            title: "Theme",
            initialSelectedActionKey: InitialTheme.of(context)?.mode,
            actions: themeModeActions,
          );
          if (result != null) {
            InitialTheme.of(context)?.setThemeMode(result);
          }
        },
        onPressed: () {
          InitialTheme.of(context)?.toggleThemeMode();
        },
      ),
    );
  }

  List<AlertDialogAction<ThemeMode>> get themeModeActions {
    return ThemeMode.values.map((e) {
      return AlertDialogAction(
        key: e,
        label: e.name.capitalize!,
      );
    }).toList();
  }
}
