library explore_view;

import 'package:spooky/core/base/view_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/util_widgets/sp_date_picker.dart';
import 'package:spooky/views/budgets/local_widgets/budgets_plans.dart';
import 'package:spooky/views/budgets/local_widgets/budgets_transactions.dart';
import 'package:spooky/widgets/sp_cross_fade.dart';
import 'package:spooky/widgets/sp_icon_button.dart';
import 'package:spooky/widgets/sp_scale_in.dart';
import 'package:spooky/widgets/sp_show_hide_animator.dart';
import 'package:spooky/widgets/sp_tab_view.dart';
import 'package:spooky/widgets/sp_tap_effect.dart';
import 'budgets_view_model.dart';

part 'budgets_mobile.dart';

class BudgetsView extends StatelessWidget {
  const BudgetsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<BudgetsViewModel>(
      create: (BuildContext context) => BudgetsViewModel(),
      builder: (context, viewModel, child) {
        return _BudgetsMobile(viewModel);
      },
    );
  }
}
