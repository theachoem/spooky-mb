import 'package:flutter/material.dart';
import 'package:spooky_mb/views/archives/archives_view.dart';
import 'package:spooky_mb/views/backups/backups_view.dart';
import 'package:spooky_mb/views/setting/setting_view.dart';
import 'package:spooky_mb/views/tags/tags_view.dart';
import 'package:spooky_mb/views/theme/theme_view.dart';
import 'package:spooky_mb/widgets/sp_nested_navigation.dart';

class HomeEndDrawer extends StatelessWidget {
  const HomeEndDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SpNestedNavigation(
        initialScreen: _Drawer(
          popDrawer: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }
}

class _Drawer extends StatelessWidget {
  const _Drawer({
    required this.popDrawer,
  });

  final void Function() popDrawer;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        buildTiles(context),
        const Positioned(
          left: 0,
          right: 0,
          bottom: 16,
          child: Text(
            "Spooky v2.0.0",
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget buildTiles(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.search),
          title: const Text('Search'),
          onTap: () {
            popDrawer();
          },
        ),
        ListTile(
          leading: const Icon(Icons.sell_outlined),
          title: const Text('Tags'),
          onTap: () {
            SpNestedNavigation.maybeOf(context)?.pushShareAxis(const TagsView());
          },
        ),
        ListTile(
          leading: const Icon(Icons.archive_outlined),
          title: const Text('Archives / Bin'),
          onTap: () {
            SpNestedNavigation.maybeOf(context)?.pushShareAxis(const ArchivesView());
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.backup_outlined),
          title: const Text('Backups'),
          subtitle: const Text('Last back up 2 days ago'),
          onTap: () {
            SpNestedNavigation.maybeOf(context)?.pushShareAxis(const BackupsView());
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.color_lens_outlined),
          title: const Text('Theme'),
          onTap: () {
            SpNestedNavigation.maybeOf(context)?.pushShareAxis(const ThemeView());
          },
        ),
        ListTile(
          leading: const Icon(Icons.settings_outlined),
          title: const Text('Settings'),
          onTap: () {
            SpNestedNavigation.maybeOf(context)?.pushShareAxis(const SettingView());
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.rate_review_outlined),
          title: const Text('Rate'),
          onTap: () {
            popDrawer();
          },
        ),
      ],
    );
  }
}
