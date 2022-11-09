import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:spooky/views/budgets/plans/ftt_rule/budget_pie_chart.dart';
import 'package:spooky/views/budgets/plans/ftt_rule/ftt_bar_chart.dart';
import 'package:spooky/widgets/sp_icon_button.dart';
import 'package:spooky/widgets/sp_pop_button.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class FttRuleScreen extends StatefulWidget {
  const FttRuleScreen({super.key});

  @override
  State<FttRuleScreen> createState() => _FttRuleScreenState();
}

class _FttRuleScreenState extends State<FttRuleScreen> {
  @override
  Widget build(BuildContext context) {
    double budget = 400;
    return Scaffold(
      appBar: MorphingAppBar(
        leading: const SpPopButton(),
        title: const Text("50-30-20 rules"),
        actions: [
          SpIconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              showTextInputDialog(
                context: context,
                title: "Set starting budget",
                textFields: [
                  DialogTextField(
                    initialText: budget.toString(),
                    validator: (value) {
                      if (double.tryParse(value ?? "") == null) {
                        return "Invalid amount";
                      }
                      return null;
                    },
                  ),
                ],
              );
            },
          )
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: BudgetPieChart(budget: budget),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              child: const Divider(height: 1),
            ),
          ),
          SliverToBoxAdapter(
            child: FttBarChart(budget: budget),
          ),
        ],
      ),
    );
  }
}
