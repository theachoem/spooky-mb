library changes_history_view;

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:provider/provider.dart';
import 'package:spooky/core/models/story_content_model.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:spooky/core/routes/sp_route_config.dart';
import 'package:spooky/widgets/sp_animated_icon.dart';
import 'package:spooky/widgets/sp_cross_fade.dart';
import 'package:spooky/widgets/sp_icon_button.dart';
import 'package:spooky/widgets/sp_pop_button.dart';
import 'package:spooky/widgets/sp_pop_up_menu_button.dart';
import 'package:spooky/widgets/sp_screen_type_layout.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/helpers/date_format_helper.dart';

import 'package:flutter/material.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'changes_history_view_model.dart';

part 'changes_history_mobile.dart';
part 'changes_history_tablet.dart';
part 'changes_history_desktop.dart';

class ChangesHistoryView extends StatelessWidget {
  const ChangesHistoryView({
    Key? key,
    required this.story,
    required this.onRestorePressed,
    required this.onDeletePressed,
  }) : super(key: key);

  final StoryModel story;
  final void Function(StoryContentModel content) onRestorePressed;
  final void Function(List<String> contentIds) onDeletePressed;

  @override
  Widget build(BuildContext context) {
    return ListenableProvider(
      create: (BuildContext context) => ChangesHistoryViewModel(story, onRestorePressed, onDeletePressed),
      builder: (context, child) {
        ChangesHistoryViewModel model = Provider.of<ChangesHistoryViewModel>(context);
        return SpScreenTypeLayout(
          mobile: _ChangesHistoryMobile(model),
          desktop: _ChangesHistoryDesktop(model),
          tablet: _ChangesHistoryTablet(model),
        );
      },
    );
  }
}
