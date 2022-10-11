import 'package:flutter/material.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/utils/constants/config_constant.dart';

class SpAppBarTitle extends StatelessWidget {
  const SpAppBarTitle({
    Key? key,
    required this.fallbackRouter,
    this.overridedTitle,
    this.icon,
  }) : super(key: key);

  final SpRouter? fallbackRouter;
  final String? overridedTitle;
  final IconData? icon;

  static SpRouter? fromName(String? name) {
    SpRouter? router;
    for (SpRouter e in SpRouter.values) {
      if (e.path == name) {
        router = e;
        break;
      }
    }
    return router;
  }

  static SpRouter? router(
    BuildContext context, [
    SpRouter? fallbackRouter,
  ]) {
    String? name = ModalRoute.of(context)?.settings.name;
    return fromName(name) ?? fallbackRouter;
  }

  @override
  Widget build(BuildContext context) {
    String? title = overridedTitle ?? fallbackRouter?.datas.title ?? router(context)?.datas.title;

    if (icon != null) {
      return RichText(
        text: TextSpan(
          text: title ?? "",
          style: Theme.of(context).appBarTheme.titleTextStyle,
          children: [
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Icon(
                  icon,
                  size: ConfigConstant.iconSize1,
                ),
              ),
            )
          ],
        ),
      );
    } else {
      return Text(
        title ?? "",
        style: Theme.of(context).appBarTheme.titleTextStyle,
      );
    }
  }
}
