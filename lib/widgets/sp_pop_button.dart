import 'package:flutter/material.dart';
import 'package:navigation_history_observer/navigation_history_observer.dart';
import 'package:popover/popover.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/views/main/main_view_item.dart';
import 'package:spooky/widgets/sp_app_bar_title.dart';
import 'package:spooky/widgets/sp_fade_in.dart';
import 'package:spooky/widgets/sp_icon_button.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/widgets/sp_scale_in.dart';

class SpPopButton extends StatelessWidget {
  const SpPopButton({
    Key? key,
    this.color,
    this.backgroundColor,
    this.onPressed,
    this.forceCloseButton = false,
  }) : super(key: key);

  final Color? color;
  final Color? backgroundColor;
  final VoidCallback? onPressed;
  final bool forceCloseButton;

  static IconData getIconData(BuildContext context) {
    final platform = Theme.of(context).platform;
    switch (platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return Icons.arrow_back;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return Icons.arrow_back_ios;
    }
  }

  @override
  Widget build(BuildContext context) {
    ModalRoute<Object?>? parentRoute = ModalRoute.of(context);
    bool useCloseButton = parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog || forceCloseButton;
    final routeHistory = NavigationHistoryObserver().history;

    List<Route<dynamic>> history = [...routeHistory.toList()].where((element) {
      return ModalRoute.of(context)?.settings.name != element.settings.name;
    }).toList();

    return Center(
      child: SpIconButton(
        backgroundColor: backgroundColor,
        icon: IconTheme.merge(
          data: IconThemeData(size: ConfigConstant.iconSize2, color: color),
          child: useCloseButton ? const Icon(Icons.close) : const BackButtonIcon(),
        ),
        tooltip: useCloseButton
            ? MaterialLocalizations.of(context).closeButtonLabel
            : MaterialLocalizations.of(context).backButtonTooltip,
        onLongPress: history.length > 1 ? () => onLongPress(history, context) : null,
        onPressed: () {
          if (onPressed != null) {
            onPressed!();
          } else {
            Navigator.maybePop(context);
          }
        },
      ),
    );
  }

  void onLongPress(List<Route<dynamic>> history, BuildContext context) {
    void pop(Route<dynamic> til) {
      Navigator.of(context).popUntil((route) {
        return route.hashCode == til.hashCode;
      });
    }

    showPopover(
      context: context,
      backgroundColor: Colors.transparent,
      shadow: [],
      radius: 0,
      contentDyOffset: 2.0,
      transitionDuration: const Duration(milliseconds: 0),
      bodyBuilder: (context) => buildRouteHistory(context, history, pop),
      direction: PopoverDirection.bottom,
      width: 200,
      height: kToolbarHeight * history.length,
      arrowHeight: 4,
      arrowWidth: 8,
      onPop: () {},
    );
  }

  Widget buildRouteHistory(
    BuildContext context,
    List<Route<dynamic>> history,
    void Function(Route<dynamic> til) pop,
  ) {
    return SpScaleIn(
      curve: Curves.fastLinearToSlowEaseIn,
      transformAlignment: Alignment.center,
      duration: ConfigConstant.fadeDuration,
      child: SpFadeIn(
        child: Container(
          margin: const EdgeInsets.only(left: 12.0),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: ConfigConstant.circlarRadius1,
            color: M3Color.of(context).background,
          ),
          child: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                history.length,
                (index) {
                  return buildRouteTile(
                    history,
                    index,
                    context,
                    pop,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildRouteTile(
      List<Route<dynamic>> history, int index, BuildContext context, void Function(Route<dynamic> til) pop) {
    Route<dynamic> route = history[index];
    SpRouter? router = route.settings.name == "/"
        ? SpRouter.home
        : SpAppBarTitle.fromName(
            route.settings.name,
          );

    SpRouterDatas? datas = router?.datas;
    MainTabBarItem? tab = datas?.tab;

    return ListTile(
      leading: tab != null ? Icon(tab.activeIcon) : null,
      title: Text(datas?.title ?? ""),
      onTap: () {
        Navigator.maybePop(context);
        pop(route);
      },
    );
  }
}
