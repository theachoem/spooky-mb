import 'package:flutter/material.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/widgets/sp_button.dart';

class SpSingleButtonBottomNavigation extends StatelessWidget {
  const SpSingleButtonBottomNavigation({
    Key? key,
    required this.buttonLabel,
    required this.onTap,
    this.show = true,
  }) : super(key: key);

  final String buttonLabel;
  final bool show;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        AnimatedOpacity(
          duration: ConfigConstant.fadeDuration,
          opacity: show ? 1.0 : 0.0,
          child: AnimatedContainer(
            duration: ConfigConstant.fadeDuration,
            transform: Matrix4.identity()..translate(0.0, show ? 0.0 : 8.0),
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: SpButton(
              label: buttonLabel,
              onTap: show ? onTap : null,
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).padding.bottom + ConfigConstant.margin2,
        ),
      ],
    );
  }
}
