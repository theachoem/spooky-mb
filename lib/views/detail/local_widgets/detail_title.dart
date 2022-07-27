import 'package:flutter/material.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/utils/helpers/date_format_helper.dart';
import 'package:spooky/utils/util_widgets/sp_date_picker.dart';
import 'package:spooky/views/detail/local_widgets/detail_scaffold.dart';
import 'package:spooky/widgets/sp_animated_icon.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/widgets/sp_tap_effect.dart';

class DetailTitle extends StatelessWidget {
  const DetailTitle({
    Key? key,
    required this.widget,
    required this.context,
  }) : super(key: key);

  final DetailScaffold widget;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: ValueListenableBuilder<bool>(
        valueListenable: widget.readOnlyNotifier,
        child: buildTitle(context),
        builder: (context, readOnly, child) {
          return SpTapEffect(
            onTap: readOnly ? null : () => onUpdate(context),
            child: child!,
          );
        },
      ),
    );
  }

  Future<void> onUpdate(BuildContext context) async {
    DateTime? pathDate = await SpDatePicker.showDatePicker(
      context,
      widget.viewModel.currentStory.displayPathDate,
    );
    if (pathDate != null) {
      widget.viewModel.setPathDate(pathDate);
    }
  }

  Widget buildTitle(BuildContext context) {
    final story = widget.viewModel.currentStory;
    return Row(
      children: [
        Text(
          story.day.toString(),
          style: M3TextTheme.of(context).headlineLarge?.copyWith(color: M3Color.of(context).primary),
        ),
        ConfigConstant.sizedBoxW0,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(getDayOfMonthSuffix(story.day).toLowerCase(), style: M3TextTheme.of(context).labelSmall),
            Text(
              DateFormatHelper.yM().format(story.displayPathDate).toUpperCase(),
              style: M3TextTheme.of(context).labelMedium,
            ),
          ],
        ),
        ConfigConstant.sizedBoxW0,
        ValueListenableBuilder<bool>(
          valueListenable: widget.readOnlyNotifier,
          child: const Icon(Icons.arrow_drop_down),
          builder: (context, value, child) {
            return SpAnimatedIcons(
              showFirst: !widget.readOnlyNotifier.value,
              secondChild: const SizedBox.shrink(),
              firstChild: child!,
            );
          },
        ),
      ],
    );
  }

  String getDayOfMonthSuffix(int dayNum) {
    if (!(dayNum >= 1 && dayNum <= 31)) {
      throw Exception('Invalid day of month');
    }

    if (dayNum >= 11 && dayNum <= 13) {
      return 'th';
    }

    switch (dayNum % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
}
