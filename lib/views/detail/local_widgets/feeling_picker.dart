import 'dart:math';
import 'package:flutter/material.dart';
import 'package:spooky/core/models/feeling_model.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/utils/extensions/string_extension.dart';
import 'package:spooky/utils/constants/config_constant.dart';

class FeelingPicker extends StatefulWidget {
  const FeelingPicker({
    Key? key,
    required this.feeling,
    required this.onPicked,
  }) : super(key: key);

  final String? feeling;
  final void Function(String feeling) onPicked;

  @override
  State<FeelingPicker> createState() => _FeelingPickerState();
}

class _FeelingPickerState extends State<FeelingPicker> {
  late final ScrollController controller;
  late final List<MapEntry<String, FeelingModel>> feelingsMap;
  late String? feeling;

  @override
  void initState() {
    feeling = widget.feeling;
    feelingsMap = FeelingModel.feelingsMap.entries.toList();
    controller = ScrollController();
    animateToInitialFeeling();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void animateToInitialFeeling() {
    double offset = findInitialScrollOffset(feeling) - 8;
    if (offset > 0) {
      Future.delayed(ConfigConstant.fadeDuration).then((value) {
        controller.animateTo(
          offset,
          duration: Duration(milliseconds: 100 * offset ~/ 100),
          curve: Curves.fastOutSlowIn,
        );
      });
    }
  }

  void onPicked(String feeling) {
    widget.onPicked(feeling);
  }

  double findInitialScrollOffset(String? selectedFeeling) {
    if (selectedFeeling == null) return 0;

    FeelingModel? selected = FeelingModel.feelingsMap[selectedFeeling];
    List<String> keysList = FeelingModel.feelingsMap.keys.toList();

    if (selected != null) {
      int index = keysList.indexOf(selectedFeeling);
      int rowIndex = (index / 3).floor();
      int lastRow = keysList.length - 3 * 1;

      // scroll to -2 on last row, while -1 on other
      // to made them in middle on grid of 3
      if (index > lastRow) {
        rowIndex = max(0, rowIndex - 2);
        return rowIndex * 100;
      } else {
        rowIndex = max(0, rowIndex - 1);
        return rowIndex * 100;
      }
    }

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: 300,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: M3Color.of(context).background,
        borderRadius: ConfigConstant.circlarRadius2,
        border: Border.all(color: M3Color.of(context).onBackground.withOpacity(0.1), width: 1),
      ),
      child: GridView.builder(
        controller: controller,
        padding: EdgeInsets.zero,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemCount: feelingsMap.length,
        cacheExtent: 100,
        itemBuilder: (context, index) {
          final feeling = feelingsMap[index];
          return Material(
            color: this.feeling == feeling.key ? M3Color.of(context).readOnly.surface1 : Colors.transparent,
            child: InkWell(
              onTap: () => onPicked(feeling.key),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    feeling.value.image64.image(
                      width: ConfigConstant.iconSize3 + 8,
                      height: ConfigConstant.iconSize3 + 8,
                    ),
                    ConfigConstant.sizedBoxH1,
                    Text(
                      feeling.value.value.replaceAll("_", " ").capitalize,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
