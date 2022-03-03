library cloud_storage_view;

import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'cloud_storage_view_model.dart';

part 'cloud_storage_mobile.dart';
part 'cloud_storage_tablet.dart';
part 'cloud_storage_desktop.dart';

class CloudStorageView extends StatelessWidget {
  const CloudStorageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<CloudStorageViewModel>(
      create: (context) => CloudStorageViewModel(),
      builder: (context, viewModel, child) {
        return ScreenTypeLayout(
          mobile: _CloudStorageMobile(viewModel),
          desktop: _CloudStorageDesktop(viewModel),
          tablet: _CloudStorageTablet(viewModel),
        );
      },
    );
  }
}
