import 'package:flutter/material.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/ui/widgets/sp_tap_effect.dart';
import 'package:spooky/utils/constants/config_constant.dart';

class SpChip extends StatelessWidget {
  const SpChip({
    Key? key,
    required this.labelText,
    this.avatar,
    this.onTap,
  }) : super(key: key);

  final String labelText;
  final Widget? avatar;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return SpTapEffect(
      effects: const [SpTapEffectType.scaleDown],
      onTap: onTap,
      child: Chip(
        label: Text(
          labelText,
          style: M3TextTheme.of(context).labelLarge,
        ),
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: ConfigConstant.circlarRadius1,
          side: BorderSide(
            color: M3Color.of(context).outline,
          ),
        ),
        padding: const EdgeInsets.all(ConfigConstant.margin1),
        avatar: avatar,
      ),
    );
  }
}
