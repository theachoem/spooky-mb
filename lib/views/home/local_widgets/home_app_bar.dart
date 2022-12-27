import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spooky/main.dart';
import 'package:spooky/providers/nickname_provider.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/views/detail/detail_view.dart';
import 'package:spooky/views/home/home_view_model.dart';
import 'package:spooky/views/home/local_widgets/home_tab_bar.dart';
import 'package:spooky/views/home/local_widgets/home_tags_tab_bar.dart';
import 'package:spooky/views/home/local_widgets/search_theme_switcher.dart';
import 'package:spooky/views/sound_list/local_widgets/miniplayer_app_bar_background.dart';
import 'package:spooky/widgets/sp_button.dart';
import 'package:spooky/widgets/sp_fade_in.dart';
import 'package:spooky/widgets/sp_list_layout_builder.dart';
import 'package:spooky/widgets/sp_reorderable_tab_bar.dart';
import 'package:spooky/widgets/sp_story_list/sp_story_list.dart';
import 'package:spooky/widgets/sp_tap_effect.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/mixins/stateful_mixin.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class HomeAppBar extends StatefulWidget {
  const HomeAppBar({
    Key? key,
    required this.tabs,
    required this.subtitle,
    required this.tabController,
    required this.viewModel,
    required this.useDefaultTabStyle,
    required this.docsCountNotifier,
    required this.onReorder,
    this.reorderable,
    this.onTap,
  }) : super(key: key);

  final bool Function(int index)? reorderable;
  final List<HomeTabItem> tabs;
  final TabController? tabController;
  final HomeViewModel viewModel;
  final ValueChanged<int>? onTap;
  final ValueNotifier<int> docsCountNotifier;
  final String Function(int docsCount) subtitle;
  final bool useDefaultTabStyle;
  final void Function(int oldIndex, int newIndex) onReorder;

  @override
  State<HomeAppBar> createState() => HomeAppBarState();
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

class HomeAppBarState extends State<HomeAppBar> with StatefulMixin, SingleTickerProviderStateMixin {
  late final AnimationController controller;
  double get animationValue => controller.drive(CurveTween(curve: Curves.ease)).value;

  late final ValueNotifier<bool> tabEditingNotifier;
  BuildContext? tabContext;

  void toggleTabEditing() {
    if (tabContext == null) return;
    final tabState = SpReorderableTabBar.of(tabContext!);
    if (tabState == null) return;

    tabState.setEditing(!tabState.editing);
    tabEditingNotifier.value = tabState.editing;
  }

  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: ConfigConstant.fadeDuration);
    tabEditingNotifier = ValueNotifier(false);
    super.initState();
    handle();
  }

  @override
  void dispose() {
    controller.dispose();
    tabEditingNotifier.dispose();
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
      return HomeTagsTabBar(
        widget: widget,
        parentState: this,
        reorderable: widget.reorderable,
      );
    } else {
      return HomeTabBar(
        height: 40,
        onTap: widget.onTap,
        controller: widget.tabController,
        viewModel: widget.viewModel,
        tabs: List.generate(
          widget.tabs.length,
          (index) => widget.tabs[index].label,
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
      background: Stack(
        children: [
          MiniplayerAppBarBackground(
            wave: Global.instance.layoutType == SpListLayoutType.timeline ? 0.75 : 0.55,
          ),
          Positioned.fill(
            child: Container(
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
                          child: ValueListenableBuilder<int>(
                            valueListenable: widget.docsCountNotifier,
                            builder: (context, docsCount, child) {
                              return Text(
                                widget.subtitle(docsCount),
                                style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    right: 0,
                    child: buildActionButtons(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTitle() {
    return SpTapEffect(
      onTap: () => widget.viewModel.openNicknameEditor(context),
      child: Consumer<NicknameProvider>(
        builder: (context, provider, child) {
          return Text(
            tr("msg.hello_user", args: ["${provider.name}"]),
            style: textTheme.titleLarge?.copyWith(color: colorScheme.primary),
          );
        },
      ),
    );
  }

  Widget buildActionButtons() {
    return ValueListenableBuilder<bool>(
      valueListenable: tabEditingNotifier,
      builder: (context, editing, child) {
        return Stack(
          alignment: Alignment.centerRight,
          children: [
            Visibility(
              visible: editing,
              child: SpButton(
                backgroundColor: Colors.transparent,
                foregroundColor: M3Color.of(context).primary,
                borderColor: M3Color.of(context).primary,
                label: tr('button.done'),
                onTap: () => toggleTabEditing(),
              ),
            ),
            Visibility(
              visible: !editing,
              child: SpFadeIn(
                duration: ConfigConstant.fadeDuration * 2,
                child: const SizedBox(
                  width: kToolbarHeight,
                  height: kToolbarHeight - 8,
                  child: SearchThemeSwicher(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
