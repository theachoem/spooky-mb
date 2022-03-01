library explore_view;

import 'package:provider/provider.dart';
import 'package:spooky/widgets/sp_screen_type_layout.dart';

import 'package:flutter/material.dart';
import 'explore_view_model.dart';

part 'explore_mobile.dart';
part 'explore_tablet.dart';
part 'explore_desktop.dart';

class ExploreView extends StatelessWidget {
  const ExploreView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListenableProvider(
      create: (BuildContext context) => ExploreViewModel(),
      builder: (context, child) {
        ExploreViewModel model = Provider.of<ExploreViewModel>(context);
        return SpScreenTypeLayout(
          mobile: _ExploreMobile(model),
          desktop: _ExploreDesktop(model),
          tablet: _ExploreTablet(model),
        );
      },
    );
  }
}
