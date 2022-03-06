import 'package:flutter/material.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/widgets/sp_tap_effect.dart';

class SpButton extends StatelessWidget {
  const SpButton({
    Key? key,
    this.onTap,
    required this.label,
    this.backgroundColor,
    this.foregroundColor,
  }) : super(key: key);

  final VoidCallback? onTap;
  final String label;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    return SpTapEffect(
      onTap: onTap,
      effects: const [SpTapEffectType.scaleDown],
      child: TextButton(
        onPressed: null,
        child: Text(
          "  $label  ",
          style: M3TextTheme.of(context).labelLarge?.copyWith(color: foregroundColor ?? M3Color.of(context).onPrimary),
        ),
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor ?? M3Color.of(context).primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(48),
          ),
        ),
      ),
    );
  }
}
