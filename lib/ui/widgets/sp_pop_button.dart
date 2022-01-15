import 'package:flutter/material.dart';
import 'package:spooky/ui/widgets/sp_icon_button.dart';
import 'package:spooky/utils/constants/config_constant.dart';

class SpPopButton extends StatelessWidget {
  const SpPopButton({
    Key? key,
    this.color,
    this.backgroundColor,
    this.onPressed,
  }) : super(key: key);

  final Color? color;
  final Color? backgroundColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    ModalRoute<Object?>? parentRoute = ModalRoute.of(context);
    bool useCloseButton = parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog;
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
