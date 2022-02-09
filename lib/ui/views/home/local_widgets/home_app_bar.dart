import 'package:flutter/material.dart';
import 'package:spooky/app.dart';
import 'package:spooky/ui/views/home/home_view_model.dart';
import 'package:spooky/ui/views/home/local_widgets/home_tab_bar.dart';
import 'package:spooky/ui/widgets/sp_tap_effect.dart';
import 'package:spooky/ui/widgets/sp_theme_switcher.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/mixins/stateful_mixin.dart';

class HomeAppBar extends StatefulWidget {
  const HomeAppBar({
    Key? key,
    required this.subtitle,
    required this.tabLabels,
    required this.tabController,
    required this.viewModel,
  }) : super(key: key);

  final String subtitle;
  final List<String> tabLabels;
  final TabController tabController;
  final HomeViewModel viewModel;

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
        stretchModes: const [
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
              buildTitle(),
              ConfigConstant.sizedBoxH0,
              SpTapEffect(
                onTap: () => widget.viewModel.pickYear(context),
                child: Text(
                  widget.subtitle,
                  style: textTheme.bodyText2?.copyWith(color: colorScheme.onSurface),
                ),
              ),
            ],
          ),
          buildThemeSwitcherButton()
        ],
      ),
    );
  }

  Widget buildTitle() {
    return SpTapEffect(
      onTap: () => widget.viewModel.openNicknameEditor(context),
      child: ValueListenableBuilder<String?>(
        valueListenable: App.of(context)!.nicknameNotifier,
        builder: (context, value, child) {
          return Text(
            "Hello $value",
            style: textTheme.headline6?.copyWith(color: colorScheme.primary),
          );
        },
      ),
    );
  }

  Widget buildThemeSwitcherButton() {
    return Positioned(
      right: 0,
      child: SpThemeSwitcher(),
    );
  }
}
