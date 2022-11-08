import 'package:flutter/material.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/views/budgets/local_widgets/budgets_plan_object.dart';
import 'package:spooky/views/budgets/local_widgets/budgets_plan_tile.dart';

class BudgetsPlans extends StatelessWidget {
  const BudgetsPlans({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<BudgetsPlanObject> plans = BudgetsPlanObject.plans;
    return ListView.separated(
      padding: ConfigConstant.layoutPadding,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemCount: plans.length,
      itemBuilder: (context, index) {
        final BudgetsPlanObject plan = plans[index];
        return BudgetsPlanTile(plan: plan);
      },
    );
  }
}
