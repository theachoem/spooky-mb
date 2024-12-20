part of '../home_view.dart';

class _HomeEndDrawer extends StatelessWidget {
  const _HomeEndDrawer();

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
    return ListView(
      children: [
        buildHeader(context),
        const Divider(height: 1),
        const SizedBox(height: 8.0),
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

  Widget buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "2024",
            style: TextTheme.of(context).displayMedium,
          ),
          SpTapEffect(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(top: 4.0, right: 8.0, bottom: 8.0),
              child: Text(
                "Switch",
                style: TextTheme.of(context).labelLarge?.copyWith(color: ColorScheme.of(context).primary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
