library file_manager_view;

import 'dart:io';
import 'package:spooky/core/file_manager/docs_manager.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/ui/widgets/sp_animated_icon.dart';
import 'package:spooky/ui/widgets/sp_cross_fade.dart';
import 'package:spooky/ui/widgets/sp_pop_button.dart';
import 'package:spooky/ui/widgets/sp_pop_up_menu_button.dart';
import 'package:spooky/ui/widgets/sp_tap_effect.dart';
import 'package:spooky/utils/constants/app_constant.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/extensions/string_extension.dart';
import 'package:spooky/utils/helpers/date_format_helper.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'file_manager_view_model.dart';
import 'package:spooky/core/route/router.dart' as route;

part 'file_manager_mobile.dart';
part 'file_manager_tablet.dart';
part 'file_manager_desktop.dart';

enum FileManagerFlow {
  explore,
  viewChanges,
}

class FileManagerView extends StatelessWidget {
  const FileManagerView({
    Key? key,
    required this.directory,
    this.fileManagerFlow = FileManagerFlow.explore,
  }) : super(key: key);

  final Directory directory;
  final FileManagerFlow fileManagerFlow;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FileManagerViewModel>.reactive(
      viewModelBuilder: () => FileManagerViewModel(directory, fileManagerFlow),
      onModelReady: (model) {},
      builder: (context, model, child) {
        return ScreenTypeLayout(
          mobile: _FileManagerMobile(model),
          desktop: _FileManagerDesktop(model),
          tablet: _FileManagerTablet(model),
        );
      },
    );
  }
}
