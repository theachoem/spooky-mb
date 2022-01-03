library explore_view;

import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'explore_view_model.dart';
part 'explore_mobile.dart';
part 'explore_tablet.dart';
part 'explore_desktop.dart';

class ExploreView extends StatelessWidget {
  const ExploreView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ExploreViewModel>.reactive(
      viewModelBuilder: () => ExploreViewModel(),
      onModelReady: (model) {
        // Do something once your model is initialized
      },
      builder: (context, model, child) {
        return ScreenTypeLayout(
          mobile: _ExploreMobile(model),
          desktop: _ExploreDesktop(model),
          tablet: _ExploreTablet(model),
        );
      },
    );
  }
}
