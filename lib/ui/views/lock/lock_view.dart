library lock_view;

import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'lock_view_model.dart';
part 'lock_mobile.dart';
part 'lock_tablet.dart';
part 'lock_desktop.dart';

class LockView extends StatelessWidget {
  const LockView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LockViewModel>.reactive(
      viewModelBuilder: () => LockViewModel(),
      onModelReady: (model) {},
      builder: (context, model, child) {
        return ScreenTypeLayout(
          mobile: _LockMobile(model),
          desktop: _LockDesktop(model),
          tablet: _LockTablet(model),
        );
      },
    );
  }
}
