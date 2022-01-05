import 'package:flutter/material.dart';

class SpIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback onPressed;
  final double size;
  final EdgeInsets padding;
  final String? tooltip;

  const SpIconButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.size = 24.0,
    this.padding = const EdgeInsets.all(8),
    this.tooltip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget button = Material(
      type: MaterialType.transparency,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: Padding(
          padding: padding,
          child: icon,
        ),
      ),
    );

    if (tooltip != null) {
      button = Tooltip(
        message: tooltip ?? '',
        child: button,
      );
    }

    return Container(
      padding: const EdgeInsets.all(4),
      child: button,
    );
  }
}
