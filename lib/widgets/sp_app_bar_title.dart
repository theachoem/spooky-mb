import 'package:flutter/material.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/utils/constants/config_constant.dart';

class SpAppBarTitle extends StatelessWidget {
  const SpAppBarTitle({
    Key? key,
  }) : super(key: key);

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
    return TweenAnimationBuilder(
      duration: ConfigConstant.fadeDuration,
      tween: IntTween(begin: 0, end: 1),
      child: Text(
        router(context)?.title ?? "",
        style: Theme.of(context).appBarTheme.titleTextStyle,
      ),
      builder: (context, value, child) {
        return AnimatedOpacity(
          opacity: value == 1 ? 1 : 0,
          duration: ConfigConstant.fadeDuration,
          child: child,
        );
      },
    );
  }
}
