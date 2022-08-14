import 'package:flutter/material.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/widgets/sp_cross_fade.dart';
import 'package:spooky/widgets/sp_tap_effect.dart';

class SpButton extends StatelessWidget {
  const SpButton({
    Key? key,
    this.onTap,
    required this.label,
    this.iconData,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.loading = false,
  }) : super(key: key);

  final VoidCallback? onTap;
  final String label;
  final IconData? iconData;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final button = buildButton(context);
    return SpTapEffect(
      onTap: onTap,
      effects: const [SpTapEffectType.scaleDown],
      child: SpCrossFade(
        showFirst: loading,
        secondChild: button,
        firstChild: Stack(
          children: [
            // bypass method
            Opacity(opacity: 0, child: button),
            const Positioned.fill(
              child: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextButton buildButton(BuildContext context) {
    final foreground = foregroundColor ?? M3Color.of(context).onPrimary;
    final background = backgroundColor ?? M3Color.of(context).primary;

    if (iconData != null) {
      return TextButton.icon(
        icon: Icon(iconData, color: foreground),
        onPressed: null,
        style: buildButtonStyle(background),
        label: buildLabel(context, foreground),
      );
    } else {
      return TextButton(
        onPressed: null,
        style: buildButtonStyle(background),
        child: buildLabel(context, foreground),
      );
    }
  }

  ButtonStyle buildButtonStyle(Color background) {
    return TextButton.styleFrom(
      backgroundColor: background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(48),
        side: borderColor != null ? BorderSide(color: borderColor!) : BorderSide.none,
      ),
    );
  }

  Text buildLabel(BuildContext context, Color foreground) {
    return Text(
      "  $label  ",
      style: M3TextTheme.of(context).labelLarge?.copyWith(color: foreground),
    );
  }
}
