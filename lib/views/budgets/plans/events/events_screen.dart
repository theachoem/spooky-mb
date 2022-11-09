import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/views/budgets/plans/events/event_detail_screen.dart';
import 'package:spooky/widgets/sp_pop_button.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  @override
  Widget build(BuildContext context) {
    List<String> items = [
      "Siem Reap Travel",
      "Visit Hometown",
      "Pre-wedding",
      "Personal BD",
    ];

    List<String> states = [
      "Running",
      "Finished",
    ];

    return Scaffold(
      appBar: MorphingAppBar(
        leading: const SpPopButton(),
        title: const Text("Events"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: M3Color.of(context).tertiaryContainer,
        child: Icon(
          Icons.add,
          color: M3Color.of(context).tertiary,
        ),
      ),
      body: CustomScrollView(
        slivers: [
          ...List.generate(
            states.length,
            (stateIndex) {
              return SliverStickyHeader(
                header: Container(
                  height: 24.0,
                  color: M3Color.of(context).readOnly.surface4,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        states[stateIndex],
                        style: M3TextTheme.of(context).labelSmall?.copyWith(color: M3Color.of(context).secondary),
                      ),
                      // Text(
                      //   '-50\$',
                      //   style: M3TextTheme.of(context).labelSmall?.copyWith(color: M3Color.of(context).secondary),
                      // ),
                    ],
                  ),
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final title = items[index];
                      return ListTile(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                            return const EventDetailScreen();
                          }));
                        },
                        trailing: const Icon(Icons.keyboard_arrow_right),
                        leading: CircleAvatar(
                          backgroundColor: M3Color.dayColorsOf(context)[index + 1]!,
                          child: Icon(
                            Icons.event,
                            color: M3Color.of(context).onPrimary,
                          ),
                        ),
                        title: Text(title),
                        subtitle: const Text("11/12/2022 to 12/01/2023"),
                      );
                    },
                    childCount: stateIndex == 0 ? 1 : items.length,
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
