library archive_view;

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:spooky/app.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:spooky/ui/views/home/local_widgets/story_list.dart';
import 'package:spooky/utils/helpers/date_format_helper.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'archive_view_model.dart';
part 'archive_mobile.dart';
part 'archive_tablet.dart';
part 'archive_desktop.dart';

class ArchiveView extends StatelessWidget {
  const ArchiveView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ArchiveViewModel>.reactive(
      viewModelBuilder: () => ArchiveViewModel(),
      onModelReady: (model) {},
      builder: (context, model, child) {
        return ScreenTypeLayout(
          mobile: _ArchiveMobile(model),
          desktop: _ArchiveDesktop(model),
          tablet: _ArchiveTablet(model),
        );
      },
    );
  }
}
