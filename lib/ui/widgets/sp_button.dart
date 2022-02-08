import 'package:flutter/material.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/ui/widgets/sp_tap_effect.dart';

class SpButton extends StatelessWidget {
  const SpButton({
    Key? key,
    this.onTap,
    required this.label,
  }) : super(key: key);

  final VoidCallback? onTap;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SpTapEffect(
      onTap: onTap,
      effects: [SpTapEffectType.scaleDown],
      child: TextButton(
        onPressed: null,
        child: Text(
          "  $label  ",
          style: M3TextTheme.of(context).labelLarge?.copyWith(color: M3Color.of(context).primary),
        ),
        style: TextButton.styleFrom(
          backgroundColor: M3Color.of(context).onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(48),
          ),
        ),
      ),
    );
  }
}
