import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/widgets/sp_tap_effect.dart';
import 'package:sticky_headers/sticky_headers.dart';

class BillsList extends StatelessWidget {
  const BillsList({
    super.key,
    required this.categories,
  });

  final List<String> categories;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
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
                        categories[index],
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
                    4,
                    (index) {
                      return ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.red,
                          child: Icon(
                            CommunityMaterialIcons.netflix,
                            color: Colors.white,
                          ),
                        ),
                        title: const Text("Netflix"),
                        subtitle: const Text("Next bill at 12 Nov 2022"),
                        trailing: SpTapEffect(
                          onTap: () {
                            showModalActionSheet(
                              context: context,
                              title: "State",
                              actions: [
                                const SheetAction(label: "Running", key: "running"),
                                const SheetAction(label: "Finished", key: "finished"),
                              ],
                            );
                          },
                          child: Text(
                            "5\$ / monthly",
                            style: M3TextTheme.of(context).labelSmall,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
            childCount: categories.length,
          ),
        )
      ],
    );
  }
}
