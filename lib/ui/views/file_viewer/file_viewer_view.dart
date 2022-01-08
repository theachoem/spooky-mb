library file_viewer_view;

import 'dart:io';

import 'package:responsive_builder/responsive_builder.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/helpers/file_helper.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'file_viewer_view_model.dart';
part 'file_viewer_mobile.dart';
part 'file_viewer_tablet.dart';
part 'file_viewer_desktop.dart';

class FileViewerView extends StatelessWidget {
  const FileViewerView({
    Key? key,
    required this.file,
  }) : super(key: key);

  final File file;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FileViewerViewModel>.reactive(
      viewModelBuilder: () => FileViewerViewModel(file),
      onModelReady: (model) {},
      builder: (context, model, child) {
        return ScreenTypeLayout(
          mobile: _FileViewerMobile(model),
          desktop: _FileViewerDesktop(model),
          tablet: _FileViewerTablet(model),
        );
      },
    );
  }
}
