library changes_history_view;

import 'package:responsive_builder/responsive_builder.dart';
import 'package:spooky/core/models/story_content_model.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:spooky/ui/widgets/sp_pop_button.dart';
import 'package:spooky/ui/widgets/sp_pop_up_menu_button.dart';
import 'package:spooky/utils/helpers/date_format_helper.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'changes_history_view_model.dart';
import 'package:spooky/core/route/router.dart' as route;

part 'changes_history_mobile.dart';
part 'changes_history_tablet.dart';
part 'changes_history_desktop.dart';

class ChangesHistoryView extends StatelessWidget {
  const ChangesHistoryView({
    Key? key,
    required this.story,
  }) : super(key: key);

  final StoryModel story;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChangesHistoryViewModel>.reactive(
      viewModelBuilder: () => ChangesHistoryViewModel(story),
      onModelReady: (model) {},
      builder: (context, model, child) {
        return ScreenTypeLayout(
          mobile: _ChangesHistoryMobile(model),
          desktop: _ChangesHistoryDesktop(model),
          tablet: _ChangesHistoryTablet(model),
        );
      },
    );
  }
}
