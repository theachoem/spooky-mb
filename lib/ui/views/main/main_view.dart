library main_view;

import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'main_view_model.dart';
part 'main_mobile.dart';
part 'main_tablet.dart';
part 'main_desktop.dart';

class MainView extends StatelessWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(
      viewModelBuilder: () => MainViewModel(),
      onModelReady: (model) {
        // Do something once your model is initialized
      },
      builder: (context, model, child) {
        return ScreenTypeLayout(
          mobile: _MainMobile(model),
          desktop: _MainDesktop(model),
          tablet: _MainTablet(model),
        );
      },
    );
  }
}
