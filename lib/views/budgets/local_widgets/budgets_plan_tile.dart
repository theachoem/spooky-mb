import 'package:flutter/material.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/views/budgets/local_widgets/budgets_plan_object.dart';

class BudgetsPlanTile extends StatefulWidget {
  const BudgetsPlanTile({
    super.key,
    required this.plan,
  });

  final BudgetsPlanObject plan;

  @override
  State<BudgetsPlanTile> createState() => _BudgetsPlanTileState();
}

class _BudgetsPlanTileState extends State<BudgetsPlanTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => widget.plan.onPressed(context),
      shape: RoundedRectangleBorder(
        borderRadius: ConfigConstant.circlarRadius2,
        side: BorderSide(
          color: Theme.of(context).dividerColor,
        ),
      ),
      leading: CircleAvatar(
        backgroundColor: widget.plan.color(context),
        child: Icon(
          widget.plan.iconData,
          color: M3Color.of(context).onPrimary,
        ),
      ),
      title: Text(widget.plan.name),
      subtitle: Text(widget.plan.description),
      contentPadding: const EdgeInsets.only(
        left: 16.0,
        right: 4.0,
        top: 8.0,
        bottom: 8.0,
      ),
    );
  }
}
