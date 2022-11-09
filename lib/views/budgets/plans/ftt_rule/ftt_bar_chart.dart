import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/utils/helpers/app_helper.dart';

class FttBarChart extends StatelessWidget {
  const FttBarChart({
    super.key,
    required this.budget,
  });

  final double budget;

  @override
  Widget build(BuildContext context) {
    final int digit = budget.toInt().toString().length;

    final int mockDigit = int.tryParse("1${"0" * digit}")!;
    final int mockMaxDigit = int.tryParse("1${"0" * 3}")!;

    final double mockBudget = budget * mockMaxDigit / mockDigit;

    final int per = mockBudget ~/ 5;
    final List<int> sections = List.generate(5, (index) => per * (index + 1));

    return SizedBox(
      height: 200,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BarChart(
          BarChartData(
            maxY: mockBudget,
            minY: 0,
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                tooltipBgColor: M3Color.of(context).readOnly.surface5,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  final List<String> ideas = [
                    "50% of budgets",
                    "30% of budgets",
                    "20% of budgets",
                  ];
                  final amount = rod.toY * mockDigit / mockMaxDigit;
                  return BarTooltipItem(
                    "${rodIndex == 1 ? "Actual spend" : ideas[groupIndex]}\n\$ $amount",
                    M3TextTheme.of(context).labelSmall!,
                  );
                },
              ),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 1,
              checkToShowHorizontalLine: (value) {
                return sections.map((e) => e).contains(value) || sections.last - 1 == value;
              },
            ),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              rightTitles: AxisTitles(),
              topTitles: AxisTitles(),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  reservedSize: 64,
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    if (sections.map((e) => e).contains(value)) {
                      final amount = value.toInt() * mockDigit / mockMaxDigit;
                      final display = AppHelper.kMBGenerator(amount);
                      return Text(
                        "\$ $display",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final List<String> values = [
                      "Need",
                      "Want",
                      "Saving",
                    ];
                    return Text(values[value.toInt() - 1]);
                  },
                ),
              ),
            ),
            barGroups: [
              BarChartGroupData(
                x: 1,
                barsSpace: 4.0,
                barRods: [
                  BarChartRodData(
                    toY: mockBudget * 0.5,
                    color: M3Color.dayColorsOf(context)[1]?.withOpacity(0.25),
                  ),
                  BarChartRodData(
                    toY: mockBudget * 0.3,
                    color: M3Color.dayColorsOf(context)[1],
                  ),
                ],
              ),
              BarChartGroupData(
                x: 2,
                barsSpace: 4.0,
                barRods: [
                  BarChartRodData(
                    toY: mockBudget * 0.3,
                    color: M3Color.dayColorsOf(context)[2]?.withOpacity(0.25),
                  ),
                  BarChartRodData(
                    toY: mockBudget * 0.2,
                    color: M3Color.dayColorsOf(context)[2],
                  ),
                ],
              ),
              BarChartGroupData(
                x: 3,
                barsSpace: 4.0,
                barRods: [
                  BarChartRodData(
                    toY: mockBudget * 0.2,
                    color: M3Color.dayColorsOf(context)[3]?.withOpacity(0.25),
                  ),
                  BarChartRodData(
                    toY: mockBudget * 0.1,
                    color: M3Color.dayColorsOf(context)[3],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
