library home_view;

import 'package:auto_route/auto_route.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'home_view_model.dart';
import 'package:spooky/core/route/router.gr.dart' as r;

part 'home_mobile.dart';
part 'home_tablet.dart';
part 'home_desktop.dart';

class HomeView extends StatelessWidget {
  const HomeView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onModelReady: (model) {},
      builder: (context, model, child) {
        return ScreenTypeLayout(
          mobile: _HomeMobile(model),
          desktop: _HomeDesktop(model),
          tablet: _HomeTablet(model),
        );
      },
    );
  }
}
