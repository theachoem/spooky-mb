library restores_view;

import 'package:responsive_builder/responsive_builder.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'package:flutter/material.dart';
import 'restores_view_model.dart';

part 'restores_mobile.dart';
part 'restores_tablet.dart';
part 'restores_desktop.dart';

class RestoresView extends StatelessWidget {
  const RestoresView({
    Key? key,
    required this.showSkipButton,
  }) : super(key: key);

  final bool showSkipButton;

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<RestoresViewModel>(
      create: (context) => RestoresViewModel(showSkipButton),
      onModelReady: (context, viewModel) {},
      builder: (context, viewModel, child) {
        return ScreenTypeLayout(
          mobile: _RestoresMobile(viewModel),
          desktop: _RestoresDesktop(viewModel),
          tablet: _RestoresTablet(viewModel),
        );
      },
    );
  }
}
