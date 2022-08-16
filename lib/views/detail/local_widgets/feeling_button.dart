import 'package:animated_clipper/animated_clipper.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/models/feeling_model.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/views/detail/local_widgets/feeling_picker.dart';
import 'package:spooky/widgets/sp_floating_popup_button.dart';
import 'package:spooky/widgets/sp_icon_button.dart';
import 'package:spooky/utils/constants/config_constant.dart';

class FeelingButton extends StatelessWidget {
  const FeelingButton({
    Key? key,
    required this.onPicked,
    required this.feeling,
  }) : super(key: key);

  final String? feeling;
  final void Function(String feeling) onPicked;

  @override
  Widget build(BuildContext context) {
    return SpFloatingPopUpButton(
      cacheFloatingSize: 300,
      bottomToTop: false,
      dyGetter: (dy) => dy + 64,
      pathBuilder: PathBuilders.slideDown,
      floatBuilder: (void Function() callback) {
        return FeelingPicker(
          feeling: feeling,
          onPicked: (feeling) {
            onPicked(feeling);
            callback();
          },
        );
      },
      builder: (callback) {
        return SpIconButton(
          icon: FeelingModel.feelingsMap[feeling]?.image64.image(width: ConfigConstant.iconSize2) ??
              const Icon(Icons.add_reaction_sharp),
          backgroundColor: M3Color.of(context).readOnly.surface1,
          onPressed: callback,
        );
      },
    );
  }
}
