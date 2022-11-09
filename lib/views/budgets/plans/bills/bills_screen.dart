import 'package:flutter/material.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/views/budgets/plans/bills/bill_detail_screen.dart';
import 'package:spooky/views/budgets/plans/bills/bills_list.dart';
import 'package:spooky/widgets/sp_icon_button.dart';
import 'package:spooky/widgets/sp_pop_button.dart';
import 'package:spooky/widgets/sp_tab_view.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class BillsScreen extends StatefulWidget {
  const BillsScreen({super.key});

  @override
  State<BillsScreen> createState() => _BillsScreenState();
}

class _BillsScreenState extends State<BillsScreen> {
  @override
  Widget build(BuildContext context) {
    List<String> categories = [
      "Internet",
      "Food & Beverage",
      "Transportation",
    ];

    // List<String> states = [
    //   "Running",
    //   "Finished",
    // ];

    List<String> lies = [
      "Yearly",
      "Monthly",
      "Weekly",
    ];

    return DefaultTabController(
      length: lies.length,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: M3Color.of(context).tertiaryContainer,
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return const BillDetailScreen();
            }));
          },
        ),
        appBar: MorphingAppBar(
          leading: const SpPopButton(),
          title: Text(
            "Bills",
            style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
          bottom: TabBar(
            tabs: List.generate(lies.length, (index) {
              return Tab(
                text: lies[index],
              );
            }),
          ),
          actions: [
            Center(
              child: SpIconButton(
                icon: const Icon(Icons.tune),
                onPressed: () {},
              ),
            ),
          ],
        ),
        body: SpTabView(
          children: [
            BillsList(categories: categories),
            BillsList(categories: categories),
            BillsList(categories: categories),
          ],
        ),
      ),
    );
  }
}
