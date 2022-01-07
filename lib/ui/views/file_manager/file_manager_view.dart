library file_manager_view;

import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'file_manager_view_model.dart';
part 'file_manager_mobile.dart';
part 'file_manager_tablet.dart';
part 'file_manager_desktop.dart';

class FileManagerView extends StatelessWidget {
  const FileManagerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FileManagerViewModel>.reactive(
      viewModelBuilder: () => FileManagerViewModel(),
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
