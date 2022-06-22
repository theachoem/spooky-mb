import 'package:flutter/material.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/widgets/sp_app_bar_title.dart';
import 'package:spooky/widgets/sp_fade_in.dart';
import 'package:spooky/widgets/sp_pop_button.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'package:spooky/core/routes/sp_router.dart';

class SpExpandedAppBar extends StatelessWidget {
  const SpExpandedAppBar({
    Key? key,
    required this.expandedHeight,
    required this.actions,
    this.subtitleIcon,
    this.backgroundColor,
    this.collapsedHeight,
    this.fallbackRouter,
  }) : super(key: key);

  final double expandedHeight;
  final double? collapsedHeight;
  final IconData? subtitleIcon;
  final List<Widget> actions;
  final Color? backgroundColor;
  final SpRouter? fallbackRouter;

  @override
  Widget build(BuildContext context) {
    final SpRouter? fallbackRouter = this.fallbackRouter ?? SpAppBarTitle.router(context);
    return MorphingSliverAppBar(
      expandedHeight: expandedHeight,
      collapsedHeight: collapsedHeight,
      backgroundColor: backgroundColor,
      leading: const SpPopButton(),
      pinned: true,
      floating: true,
      stretch: true,
      title: const Text(""),
      elevation: Theme.of(context).appBarTheme.elevation,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.none,
        background: SpFadeIn(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(top: 72.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  fallbackRouter?.title ?? "",
                  style: Theme.of(context).appBarTheme.titleTextStyle,
                  textAlign: TextAlign.center,
                ),
                ConfigConstant.sizedBoxH1,
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: [
                      TextSpan(text: fallbackRouter?.subtitle ?? ""),
                      if (subtitleIcon != null)
                        WidgetSpan(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Icon(
                              subtitleIcon,
                              size: ConfigConstant.iconSize1,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: actions,
    );
  }
}
