import 'package:flutter/material.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/utils/constants/config_constant.dart';

class SpSmallChip extends StatelessWidget {
  const SpSmallChip({
    Key? key,
    required this.label,
  }) : super(key: key);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: ConfigConstant.margin0 + 2, vertical: 2),
      decoration: BoxDecoration(
        color: M3Color.of(context).secondary,
        borderRadius: ConfigConstant.circlarRadius1,
      ),
      child: Text(
        label,
        style: M3TextTheme.of(context).labelSmall?.copyWith(color: M3Color.of(context).onSecondary),
      ),
    );
  }
}
