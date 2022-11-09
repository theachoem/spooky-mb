import 'dart:math';

import 'package:flutter/material.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:sticky_headers/sticky_headers.dart';

class TransactionsList extends StatelessWidget {
  const TransactionsList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return StickyHeader(
            header: Container(
              height: 24.0,
              color: M3Color.of(context).readOnly.surface4,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Nov 7, 2022',
                    style: M3TextTheme.of(context).labelSmall?.copyWith(color: M3Color.of(context).secondary),
                  ),
                  Text(
                    '-50\$',
                    style: M3TextTheme.of(context).labelSmall?.copyWith(color: M3Color.of(context).secondary),
                  ),
                ],
              ),
            ),
            content: Column(
              children: List.generate(
                5,
                (index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: M3Color.dayColorsOf(context)[Random().nextInt(6) + 1],
                      child: Icon(Icons.bar_chart, color: M3Color.of(context).onPrimary),
                    ),
                    title: Text("\$${5 + Random().nextInt(20)}"),
                    subtitle: const Text("Food & Beverage"),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
