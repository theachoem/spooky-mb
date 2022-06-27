import 'package:flutter/material.dart';
import 'package:spooky/core/routes/sp_router.dart';

class SpAppBarTitle extends StatelessWidget {
  const SpAppBarTitle({
    Key? key,
    required this.fallbackRouter,
    this.overridedTitle,
  }) : super(key: key);

  final SpRouter? fallbackRouter;
  final String? overridedTitle;

  static SpRouter? router(
    BuildContext context, [
    SpRouter? fallbackRouter,
  ]) {
    String? name = ModalRoute.of(context)?.settings.name;
    SpRouter? router;
    for (SpRouter e in SpRouter.values) {
      if (e.path == name) {
        router = e;
        break;
      }
    }
    return router ?? fallbackRouter;
  }

  @override
  Widget build(BuildContext context) {
    String? title = overridedTitle ?? fallbackRouter?.title ?? router(context)?.title;
    return Text(
      title ?? "",
      style: Theme.of(context).appBarTheme.titleTextStyle,
    );
  }
}
