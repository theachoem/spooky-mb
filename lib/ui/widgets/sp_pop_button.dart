import 'package:flutter/material.dart';
import 'package:spooky/ui/widgets/sp_icon_button.dart';

class SpPopButton extends StatelessWidget {
  const SpPopButton({
    Key? key,
    this.color,
    this.onPressed,
  }) : super(key: key);

  final Color? color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    ModalRoute<Object?>? parentRoute = ModalRoute.of(context);
    bool useCloseButton = parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog;
    return Center(
      child: SpIconButton(
        icon: Icon(
          useCloseButton ? Icons.close : (const BackButtonIcon() as Icon).icon,
          color: color,
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
