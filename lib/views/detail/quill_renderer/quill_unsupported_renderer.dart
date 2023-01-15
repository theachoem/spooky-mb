import 'package:flutter/material.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/widgets/sp_button.dart';

class QuillUnsupportedRenderer extends StatelessWidget {
  const QuillUnsupportedRenderer({
    Key? key,
    this.message,
    this.buttonLabel,
    this.onPressed,
  }) : super(key: key);

  final String? message;
  final String? buttonLabel;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: buttonLabel == null ? onPressed : null,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: ConfigConstant.margin2),
        padding: const EdgeInsets.symmetric(vertical: ConfigConstant.margin2, horizontal: 16.0),
        decoration: BoxDecoration(
          color: M3Color.of(context).tertiaryContainer,
          borderRadius: ConfigConstant.circlarRadius2,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error),
            ConfigConstant.sizedBoxH2,
            SelectableText(
              message ?? 'Unsupported embed type',
              textAlign: TextAlign.center,
            ),
            if (buttonLabel != null) ...[
              ConfigConstant.sizedBoxH1,
              SpButton(
                label: buttonLabel!,
                onTap: onPressed,
              ),
            ]
          ],
        ),
      ),
    );
  }
}
