import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/views/budgets/local_widgets/transactions_list.dart';
import 'package:spooky/widgets/sp_icon_button.dart';
import 'package:spooky/widgets/sp_pop_button.dart';

class EventDetailScreen extends StatefulWidget {
  const EventDetailScreen({super.key});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            leading: const SpPopButton(),
            title: FittedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Siem Reap Travel",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).appBarTheme.titleTextStyle,
                  ),
                  ConfigConstant.sizedBoxH0,
                  Text(
                    "12/12/2022 - 12/12/2023",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: M3TextTheme.of(context).labelSmall,
                  ),
                ],
              ),
            ),
            actions: [
              SpIconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {},
              )
            ],
          ),
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
                      "Starting budget",
                      style: M3TextTheme.of(context).bodyMedium,
                    ),
                    Text(
                      "110\$ / 200\$",
                      style: M3TextTheme.of(context).labelLarge,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SliverToBoxAdapter(child: Divider(height: 1)),
          const TransactionsList(),
        ],
      ),
    );
  }
}
