library security_view;

import 'package:spooky/ui/widgets/sp_screen_type_layout.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'security_view_model.dart';
part 'security_mobile.dart';
part 'security_tablet.dart';
part 'security_desktop.dart';

class SecurityView extends StatelessWidget {
  const SecurityView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SecurityViewModel>.reactive(
      viewModelBuilder: () => SecurityViewModel(),
      onModelReady: (model) {},
      builder: (context, model, child) {
        return SpScreenTypeLayout(
          mobile: _SecurityMobile(model),
          desktop: _SecurityDesktop(model),
          tablet: _SecurityTablet(model),
        );
      },
    );
  }
}
