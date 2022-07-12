import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spooky/providers/nickname_provider.dart';
import 'package:spooky/views/detail/detail_view.dart';
import 'package:spooky/views/home/home_view_model.dart';
import 'package:spooky/views/home/local_widgets/home_tab_bar.dart';
import 'package:spooky/views/home/local_widgets/search_theme_switcher.dart';
import 'package:spooky/widgets/sp_fade_in.dart';
import 'package:spooky/widgets/sp_list_layout_builder.dart';
import 'package:spooky/widgets/sp_story_list/sp_story_list.dart';
import 'package:spooky/widgets/sp_tap_effect.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/mixins/stateful_mixin.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class HomeAppBar extends StatefulWidget {
  const HomeAppBar({
    Key? key,
    required this.subtitle,
    required this.tabLabels,
    required this.tabController,
    required this.viewModel,
    required this.useDefaultTabStyle,
    this.onTap,
  }) : super(key: key);

  final String subtitle;
  final List<String> tabLabels;
  final TabController tabController;
  final HomeViewModel viewModel;
  final ValueChanged<int>? onTap;
  final bool useDefaultTabStyle;

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _FakeChild extends Widget {
  final Widget tabBar;
  final Widget flexibleSpace;

  const _FakeChild({
    required this.tabBar,
    required this.flexibleSpace,
  });

  @override
  Element createElement() {
    throw UnimplementedError();
  }
}

class _HomeAppBarState extends State<HomeAppBar> with StatefulMixin, SingleTickerProviderStateMixin {
  late final AnimationController controller;
  double get animationValue => controller.drive(CurveTween(curve: Curves.ease)).value;

  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: ConfigConstant.fadeDuration);
    super.initState();
    handle();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  SpListLayoutType? layoutType;
  void handle() async {
    SpListLayoutType layoutType = this.layoutType = await SpListLayoutBuilder.get();
    switch (layoutType) {
      case SpListLayoutType.timeline:
        if (controller.isCompleted) controller.reverse();
        break;
      case SpListLayoutType.library:
      case SpListLayoutType.diary:
        if (controller.isDismissed) controller.forward();
        break;
    }
  }

  StatelessWidget buildTab() {
    if (widget.useDefaultTabStyle) {
      return PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: Container(
          alignment: Alignment.centerLeft,
          child: TabBar(
            padding: const EdgeInsets.symmetric(horizontal: ConfigConstant.margin2),
            isScrollable: true,
            controller: widget.tabController,
            tabs: widget.tabLabels.map((e) {
              bool starred = e == "*";
              return Tab(
                text: starred ? null : e,
                child: starred ? const Icon(Icons.star) : null,
              );
            }).toList(),
          ),
        ),
      );
    } else {
      return HomeTabBar(
        height: 40,
        onTap: widget.onTap,
        controller: widget.tabController,
        tabs: List.generate(
          widget.tabLabels.length,
          (index) => widget.tabLabels[index],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      child: _FakeChild(
        flexibleSpace: buildBackground(),
        tabBar: buildTab(),
      ),
      builder: (context, child) {
        child as _FakeChild;
        bool hasTabs = animationValue == 1;
        return MorphingSliverAppBar(
          heroTag: DetailView.appBarHeroKey,
          elevation: appBarTheme.elevation,
          pinned: true,
          floating: true,
          stretch: true,
          automaticallyImplyLeading: false,
          expandedHeight: kToolbarHeight +
              lerpDouble(0.0, 48.0, animationValue)! +
              lerpDouble(8.0, 0.0, animationValue)! +
              32.0 +
              16.0,
          flexibleSpace: child.flexibleSpace,
          title: const SizedBox.shrink(),
          bottom: HomeTabBarWrapper(
            height: hasTabs ? 48 + 8 : 0,
            visible: hasTabs,
            child: child.tabBar,
          ),
        );
      },
    );
  }

  Widget buildBackground() {
    return FlexibleSpaceBar(
      collapseMode: CollapseMode.pin,
      stretchModes: const [StretchMode.zoomBackground],
      background: Container(
        padding: EdgeInsets.fromLTRB(16.0, statusBarHeight + 24.0 + 4.0, 16.0, 0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SpFadeIn(child: buildTitle()),
                ConfigConstant.sizedBoxH0,
                SpFadeIn(
                  duration: ConfigConstant.duration,
                  child: SpTapEffect(
                    onTap: () => widget.viewModel.pickYear(context),
                    child: Text(
                      widget.subtitle,
                      style: textTheme.bodyText2?.copyWith(color: colorScheme.onSurface),
                    ),
                  ),
                ),
              ],
            ),
            buildThemeSwitcherButton()
          ],
        ),
      ),
    );
  }

  Widget buildTitle() {
    return SpTapEffect(
      onTap: () => widget.viewModel.openNicknameEditor(context),
      child: Consumer<NicknameProvider>(
        builder: (context, provider, child) {
          return Text(
            "Hello ${provider.name}",
            style: textTheme.headline6?.copyWith(color: colorScheme.primary),
          );
        },
      ),
    );
  }

  Widget buildThemeSwitcherButton() {
    return Positioned(
      right: 0,
      child: SpFadeIn(
        duration: ConfigConstant.fadeDuration * 2,
        child: const SizedBox(
          width: kToolbarHeight,
          height: kToolbarHeight - 8,
          child: SearchThemeSwicher(),
        ),
      ),
    );
  }
}
