library lock_view;

import 'package:spooky/core/base/view_model_provider.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/views/lock/types/lock_flow_type.dart';
import 'package:spooky/widgets/sp_app_bar_title.dart';
import 'package:flutter/material.dart';
import 'package:spooky/widgets/sp_pop_button.dart';
import 'package:spooky/widgets/sp_single_button_bottom_navigation.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'lock_view_model.dart';

part 'lock_mobile.dart';

class LockView extends StatelessWidget {
  const LockView({
    Key? key,
    required this.flowType,
  }) : super(key: key);

  final LockFlowType flowType;

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<LockViewModel>(
      create: (BuildContext context) => LockViewModel(flowType),
      builder: (context, viewModel, child) {
        return _LockMobile(viewModel);
      },
    );
  }
}
