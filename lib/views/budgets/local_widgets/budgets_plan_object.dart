import 'package:flutter/material.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/views/budgets/plans/bills/bills_screen.dart';
import 'package:spooky/views/budgets/plans/events/events_screen.dart';
import 'package:spooky/views/budgets/plans/ftt_rule/ftt_rule_screen.dart';

class BudgetsPlanObject {
  final String name;
  final String description;
  final IconData iconData;
  final Color Function(BuildContext context) color;
  final void Function(BuildContext context) onPressed;

  BudgetsPlanObject({
    required this.name,
    required this.description,
    required this.iconData,
    required this.color,
    required this.onPressed,
  });

  static final List<BudgetsPlanObject> plans = [
    BudgetsPlanObject(
      name: "Bills",
      description: "Monthly bill include electrictiy, rent, or internet subscriptions.",
      iconData: Icons.receipt_long,
      color: (context) => M3Color.dayColorsOf(context)[1]!,
      onPressed: (context) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return const BillsScreen();
            },
          ),
        );
      },
    ),
    BudgetsPlanObject(
      name: "Events",
      description: "Plan your budget for travel or any events",
      iconData: Icons.travel_explore,
      color: (context) => M3Color.dayColorsOf(context)[2]!,
      onPressed: (context) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return const EventsScreen();
            },
          ),
        );
      },
    ),
    BudgetsPlanObject(
      name: "50 / 30 / 20 rules",
      description: "Budget plan which 50% for need, 30% for want & 20% for saving.",
      iconData: Icons.rule,
      color: (context) => M3Color.dayColorsOf(context)[3]!,
      onPressed: (context) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return const FttRuleScreen();
            },
          ),
        );
      },
    ),
  ];
}
