library explore_view;

import 'package:spooky/core/base/view_model_provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'explore_view_model.dart';

part 'explore_mobile.dart';
part 'explore_tablet.dart';
part 'explore_desktop.dart';

class ExploreView extends StatelessWidget {
  const ExploreView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ExploreViewModel>(
      create: (BuildContext context) => ExploreViewModel(),
      builder: (context, viewModel, child) {
        return ScreenTypeLayout(
          mobile: _ExploreMobile(viewModel),
          desktop: _ExploreDesktop(viewModel),
          tablet: _ExploreTablet(viewModel),
        );
      },
    );
  }
}
