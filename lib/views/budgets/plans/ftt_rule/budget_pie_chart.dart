import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/utils/constants/config_constant.dart';

class BudgetPieChart extends StatelessWidget {
  const BudgetPieChart({
    super.key,
    required this.budget,
  });

  final double budget;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 96,
          width: 88,
          alignment: Alignment.center,
          child: PieChart(
            PieChartData(
              centerSpaceRadius: 24,
              sections: [
                PieChartSectionData(
                  title: "Need",
                  value: 50,
                  radius: 8,
                  color: M3Color.dayColorsOf(context)[1],
                  showTitle: false,
                ),
                PieChartSectionData(
                  title: "Want",
                  value: 30,
                  radius: 8,
                  color: M3Color.dayColorsOf(context)[2],
                  showTitle: false,
                ),
                PieChartSectionData(
                  title: "Save",
                  value: 20,
                  radius: 8,
                  color: M3Color.dayColorsOf(context)[3],
                  showTitle: false,
                ),
              ],
            ),
          ),
        ),
        ConfigConstant.sizedBoxW0,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Starting Budget",
              style: M3TextTheme.of(context).bodyMedium,
            ),
            Text(
              "$budget\$",
              style: M3TextTheme.of(context).labelLarge,
            ),
          ],
        ),
        ConfigConstant.sizedBoxW0,
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "November",
                textAlign: TextAlign.right,
              ),
              Icon(Icons.keyboard_arrow_down)
            ],
          ),
        ),
        ConfigConstant.sizedBoxW2,
      ],
    );
  }
}
