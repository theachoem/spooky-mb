import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:popover/popover.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/views/budgets/local_widgets/transactions_list.dart';

class BudgetsTransactions extends StatelessWidget {
  const BudgetsTransactions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // SliverToBoxAdapter(
        //   child: Container(
        //     margin: const EdgeInsets.all(8.0),
        //     alignment: Alignment.center,
        //     decoration: BoxDecoration(
        //       color: M3Color.of(context).tertiaryContainer,
        //       borderRadius: ConfigConstant.circlarRadius2,
        //     ),
        //     padding: ConfigConstant.layoutPadding,
        //     child: const Text("-150\$"),
        //   ),
        // ),
        SliverToBoxAdapter(
          child: Row(
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
                        title: "A",
                        value: 10,
                        radius: 8,
                        color: M3Color.dayColorsOf(context)[1],
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        title: "B",
                        value: 8,
                        radius: 8,
                        color: M3Color.dayColorsOf(context)[2],
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        title: "C",
                        value: 4,
                        radius: 8,
                        color: M3Color.dayColorsOf(context)[3],
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        title: "D",
                        value: 6,
                        radius: 8,
                        color: M3Color.dayColorsOf(context)[4],
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        title: "E",
                        value: 10,
                        radius: 8,
                        color: M3Color.dayColorsOf(context)[5],
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
                    "Expenses",
                    style: M3TextTheme.of(context).bodyMedium,
                  ),
                  Text(
                    "80\$",
                    style: M3TextTheme.of(context).labelLarge,
                  ),
                ],
              ),
              ConfigConstant.sizedBoxW2,
              Expanded(
                child: LayoutBuilder(
                  builder: (context, contraint) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: List.generate(
                        12,
                        (index) {
                          return Container(
                            height: 88,
                            alignment: Alignment.bottomCenter,
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Builder(builder: (context) {
                              return InkWell(
                                onTap: () {
                                  showPopover(
                                    context: context,
                                    width: 200,
                                    height: 64,
                                    backgroundColor: M3Color.of(context).background,
                                    bodyBuilder: (context) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: const [
                                          Text("November"),
                                          Text("-1030\$"),
                                        ],
                                      );
                                    },
                                    onPop: () {},
                                    direction: PopoverDirection.bottom,
                                    arrowHeight: 8,
                                    arrowWidth: 16,
                                    arrowDxOffset: 0.0,
                                    arrowDyOffset: 0.0,
                                  );
                                },
                                child: Container(
                                  width: contraint.maxWidth / 12 - 4,
                                  height: Random().nextInt(16) + 4,
                                  margin: const EdgeInsets.only(right: 4.0),
                                  color:
                                      index == 11 ? M3Color.of(context).primary : M3Color.of(context).readOnly.surface1,
                                ),
                              );
                            }),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              ConfigConstant.sizedBoxW2,
            ],
          ),
        ),
        const TransactionsList()
      ],
    );
  }
}
