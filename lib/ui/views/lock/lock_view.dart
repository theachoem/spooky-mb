library lock_view;

import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/ui/views/lock/types/lock_flow_type.dart';
import 'package:spooky/ui/widgets/sp_button.dart';
import 'package:spooky/utils/constants/config_constant.dart';

import 'package:flutter/material.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'lock_view_model.dart';
part 'lock_mobile.dart';
part 'lock_tablet.dart';
part 'lock_desktop.dart';

class LockView extends StatelessWidget {
  const LockView({
    Key? key,
    required this.flowType,
  }) : super(key: key);

  final LockFlowType flowType;

  @override
  Widget build(BuildContext context) {
    return ListenableProvider(
      create: (BuildContext context) => LockViewModel(flowType),
      builder: (context, child) {
        LockViewModel model = Provider.of<LockViewModel>(context);
        return ScreenTypeLayout(
          mobile: _LockMobile(model),
          desktop: _LockDesktop(model),
          tablet: _LockTablet(model),
        );
      },
    );
  }
}
