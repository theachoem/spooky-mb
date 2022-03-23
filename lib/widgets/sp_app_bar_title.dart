import 'package:flutter/material.dart';
import 'package:spooky/core/routes/sp_router.dart';

class SpAppBarTitle extends StatelessWidget {
  const SpAppBarTitle({
    Key? key,
    required this.fallbackRouter,
  }) : super(key: key);

  final SpRouter? fallbackRouter;

  static SpRouter? router(BuildContext context) {
    String? name = ModalRoute.of(context)?.settings.name;
    SpRouter? router;
    for (SpRouter e in SpRouter.values) {
      if (e.path == name) {
        router = e;
        break;
      }
    }
    return router;
  }

  @override
  Widget build(BuildContext context) {
    String? title = router(context)?.title ?? fallbackRouter?.title;
    return Text(
      title ?? "",
      style: Theme.of(context).appBarTheme.titleTextStyle,
    );
  }
}
