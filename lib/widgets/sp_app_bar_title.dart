import 'package:flutter/material.dart';
import 'package:spooky/core/routes/sp_router.dart';

class SpAppBarTitle extends StatelessWidget {
  const SpAppBarTitle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? name = ModalRoute.of(context)?.settings.name;

    SpRouter? router;
    for (SpRouter e in SpRouter.values) {
      if (e.path == name) {
        router = e;
        break;
      }
    }

    return Text(
      router?.title ?? "",
      style: Theme.of(context).appBarTheme.titleTextStyle,
    );
  }
}
