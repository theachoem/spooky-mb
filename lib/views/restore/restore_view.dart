library restore_view;

import 'package:flutter/material.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'package:spooky/widgets/sp_screen_type_layout.dart';
import 'restore_view_model.dart';

part 'restore_mobile.dart';
part 'restore_tablet.dart';
part 'restore_desktop.dart';

class RestoreView extends StatelessWidget {
  const RestoreView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<RestoreViewModel>(
      create: (context) => RestoreViewModel(),
      builder: (context, viewModel, child) {
        return SpScreenTypeLayout(
          mobile: _RestoreMobile(viewModel),
          desktop: _RestoreDesktop(viewModel),
          tablet: _RestoreTablet(viewModel),
        );
      },
    );
  }
}
