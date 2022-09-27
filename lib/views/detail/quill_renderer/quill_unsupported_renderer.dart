import 'package:flutter/material.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/utils/constants/config_constant.dart';

class QuillUnsupportedRenderer extends StatelessWidget {
  const QuillUnsupportedRenderer({
    Key? key,
    this.message,
  }) : super(key: key);

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: ConfigConstant.margin2),
      padding: const EdgeInsets.symmetric(vertical: ConfigConstant.margin2),
      decoration: BoxDecoration(
        color: M3Color.of(context).tertiaryContainer,
        borderRadius: ConfigConstant.circlarRadius2,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const Icon(Icons.error),
          ConfigConstant.sizedBoxH1,
          Text(message ?? 'Unsupported embed type'),
        ],
      ),
    );
  }
}
