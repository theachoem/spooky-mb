library explore_view;

import 'package:spooky/core/base/view_model_provider.dart';
import 'package:flutter/material.dart';
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
