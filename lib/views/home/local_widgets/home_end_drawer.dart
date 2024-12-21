part of '../home_view.dart';

class _HomeEndDrawer extends StatelessWidget {
  const _HomeEndDrawer(this.viewModel);

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SpNestedNavigation(
        initialScreen: _EndDrawer(
          popDrawer: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }
}

class _EndDrawer extends StatelessWidget {
  const _EndDrawer({
    required this.popDrawer,
  });

  final void Function() popDrawer;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const _HomeEndDrawerHeader(),
        const Divider(height: 1),
        const SizedBox(height: 8.0),
        ListTile(
          leading: const Icon(Icons.search),
          title: const Text('Search'),
          onTap: () {
            SpNestedNavigation.maybeOf(context)?.pushShareAxis(const SearchView());
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
          leading: const Icon(Icons.language),
          title: const Text("Language"),
          subtitle: const Text("Khmer"),
          onTap: () {},
        ),
        Consumer<LocalAuthProvider>(
          builder: (context, provider, child) {
            return Visibility(
              visible: provider.canCheckBiometrics,
              child: SwitchListTile.adaptive(
                secondary: const Icon(Icons.lock),
                title: const Text('Biometrics Lock'),
                value: provider.localAuthEnabled,
                onChanged: (value) => provider.setEnable(value),
              ),
            );
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

class _HomeEndDrawerHeader extends StatelessWidget {
  const _HomeEndDrawerHeader();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => SpNestedNavigation.maybeOf(context)?.pushShareAxis(const HomeYearsView()),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "2024",
              style: TextTheme.of(context).displayMedium?.copyWith(color: ColorScheme.of(context).primary),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0, right: 8.0, bottom: 8.0),
              child: RichText(
                text: TextSpan(
                  text: "Switch",
                  style: TextTheme.of(context).labelLarge,
                  children: const [
                    WidgetSpan(
                      child: Icon(Icons.keyboard_arrow_down_outlined, size: 16.0),
                      alignment: PlaceholderAlignment.middle,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
