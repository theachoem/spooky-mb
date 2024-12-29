part of '../home_view.dart';

class _HomeEndDrawer extends StatelessWidget {
  const _HomeEndDrawer(this.viewModel);

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SpNestedNavigation(
        initialScreen: Builder(builder: (childContext) {
          return buildDrawer(
            context: childContext,
            closeDrawer: () => Navigator.of(context).pop(),
          );
        }),
      ),
    );
  }

  Widget buildDrawer({
    required BuildContext context,
    required void Function() closeDrawer,
  }) {
    return Scaffold(
      body: ListView(
        children: [
          const _HomeEndDrawerHeader(),
          const Divider(height: 1),
          const SizedBox(height: 8.0),
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text('Search'),
            onTap: () {
              SearchRoute().push(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.sell_outlined),
            title: const Text('Tags'),
            onTap: () => TagsRoute().push(context),
          ),
          ListTile(
            leading: const Icon(Icons.archive_outlined),
            title: const Text('Archives / Bin'),
            onTap: () => ArchivesRoute().push(context),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.backup_outlined),
            title: const Text('Backups'),
            subtitle: const Text('Last back up 2 days ago'),
            onTap: () => BackupSourcesRoute().push(context),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.color_lens_outlined),
            title: const Text('Theme'),
            onTap: () => ThemeRoute().push(context),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text("Language"),
            subtitle: const Text("Khmer"),
            onTap: () => const _LanguagesRoute().push(context),
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
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _HomeEndDrawerHeader extends StatelessWidget {
  const _HomeEndDrawerHeader();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeViewModel>(context);

    return InkWell(
      onTap: () => SpNestedNavigation.maybeOf(context)?.push(const HomeYearsView()),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 4.0,
          children: [
            Text(
              provider.year.toString(),
              style: TextTheme.of(context).displayMedium?.copyWith(color: ColorScheme.of(context).primary),
            ),
            RichText(
              textScaler: MediaQuery.textScalerOf(context),
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
          ],
        ),
      ),
    );
  }
}

class _LanguagesRoute extends StatelessWidget {
  const _LanguagesRoute();

  Future<T?> push<T extends Object?>(BuildContext context) {
    return SpNestedNavigation.maybeOf(context)!.push(this);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    Iterable<Locale> supportedLocales = context.findAncestorWidgetOfExactType<MaterialApp>()?.supportedLocales ?? [];

    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        itemCount: supportedLocales.length,
        itemBuilder: (context, index) {
          bool selected = themeProvider.currentLocale?.languageCode == supportedLocales.elementAt(index).languageCode;

          return ListTile(
            title: Text(supportedLocales.elementAt(index).languageCode.toUpperCase()),
            trailing: Visibility(
              visible: selected,
              child: SpFadeIn.fromBottom(
                child: const Icon(Icons.check),
              ),
            ),
            onTap: () {
              context.read<ThemeProvider>().setCurrentLocale(supportedLocales.elementAt(index));
            },
          );
        },
      ),
    );
  }
}
