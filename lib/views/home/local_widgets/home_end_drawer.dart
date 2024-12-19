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
        Consumer<ThemeProvider>(
          builder: (context, provider, child) {
            return ListTile(
              leading: SpAnimatedIcons(
                duration: Durations.medium4,
                firstChild: const Icon(Icons.dark_mode),
                secondChild: const Icon(Icons.light_mode),
                showFirst: provider.isDarkMode(context),
              ),
              title: const Text('Theme Mode'),
              subtitle: Text(provider.themeMode.name.capitalize),
              onTap: () => provider.toggleThemeMode(context),
            );
          },
        ),
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
