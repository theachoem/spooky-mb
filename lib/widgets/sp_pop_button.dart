import 'package:flutter/material.dart';
import 'package:spooky/widgets/sp_icon_button.dart';
import 'package:spooky/utils/constants/config_constant.dart';

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
}
