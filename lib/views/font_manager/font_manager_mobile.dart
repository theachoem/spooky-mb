part of font_manager_view;

class _FontManagerMobile extends StatefulWidget {
  final FontManagerViewModel viewModel;
  const _FontManagerMobile(this.viewModel);

  @override
  State<_FontManagerMobile> createState() => _FontManagerMobileState();
}

class _FontManagerMobileState extends State<_FontManagerMobile> with ScaffoldStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      appBar: MorphingAppBar(
        leading: ModalRoute.of(context)?.canPop == true ? const SpPopButton() : null,
        title: const SpAppBarTitle(fallbackRouter: SpRouter.fontManager),
        actions: [
          buildSearch(context),
          buildMoreButton(Icons.settings),
        ],
      ),
      body: FontList(
        fonts: widget.viewModel.fonts,
      ),
    );
  }

  Widget buildSearch(BuildContext context) {
    return SpIconButton(
      tooltip: "Search fonts",
      icon: const Icon(Icons.search),
      onPressed: () {
        showSearch(
          context: context,
          delegate: FontManagerSearchDelegate(
            fonts: widget.viewModel.allFonts,
            onPressed: (String fontFamily) {
              context.read<ThemeProvider>().updateFont(fontFamily);
            },
          ),
        );
      },
    );
  }

  @override
  Widget buildSheet(BuildContext context) {
    String provider = "https://fonts.google.com";
    return ListView(
      physics: const ScrollPhysics(),
      children: SpSectionsTiles.divide(
        context: context,
        sections: [
          buildSettingSection(context),
          buildInfoSection(provider, context),
        ],
      ),
    );
  }

  void openWeb(String url) async {
    AppHelper.openLinkDialog(url);
  }

  SpSectionContents buildInfoSection(String provider, BuildContext context) {
    ThemeProvider notifier = Provider.of<ThemeProvider>(context, listen: false);
    return SpSectionContents(
      headline: "Info",
      tiles: [
        ListTile(
          title: const Text("Selected Font"),
          subtitle: Text(notifier.fontFamily),
          trailing: const Icon(Icons.keyboard_arrow_right),
          onTap: () async {
            Uri? uri = Uri.tryParse(provider);
            if (uri == null) return;

            Uri queryUri = Uri(scheme: uri.scheme, host: uri.host, queryParameters: {
              "query": notifier.fontFamily,
            });

            openWeb(queryUri.toString());
          },
        ),
        ListTile(
          title: const Text("Total"),
          subtitle: Text("${widget.viewModel.allFonts.length} fonts"),
          trailing: const Icon(Icons.keyboard_arrow_right),
          onTap: () async {
            openWeb(provider);
          },
        ),
        ListTile(
          title: const Text("Provider"),
          subtitle: const Text("font.google.com"),
          trailing: const Icon(Icons.keyboard_arrow_right),
          onTap: () async {
            openWeb(provider);
          },
        ),
      ],
    );
  }

  SpSectionContents buildSettingSection(BuildContext context) {
    ThemeProvider notifier = Provider.of<ThemeProvider>(context, listen: false);
    return SpSectionContents(
      headline: "Setting",
      tiles: [
        ListTile(
          title: const Text("Font Weight"),
          trailing: const Icon(Icons.keyboard_arrow_right),
          subtitle: Text(widget.viewModel.trimFontWeight(notifier.fontWeight)),
          onTap: () async {
            // removed 100 and 900
            // since we have two type of weight in theme
            List<FontWeight> weights = FontWeight.values.toList();
            weights.removeAt(0);
            weights.removeLast();

            await showConfirmationDialog(
              context: context,
              title: "Font Weight",
              initialSelectedActionKey: notifier.fontWeight,
              actions: weights.map((e) {
                return AlertDialogAction(
                  key: e,
                  isDefaultAction: e == notifier.fontWeight,
                  label: widget.viewModel.trimFontWeight(e),
                );
              }).toList(),
            ).then((fontWeight) {
              if (fontWeight != null) {
                context.read<ThemeProvider>().updateFontWeight(fontWeight);
              }
            });
          },
        ),
        ListTile(
          title: const Text("Restore Default Style"),
          trailing: const Icon(Icons.keyboard_arrow_right),
          onTap: () {
            context.read<ThemeProvider>().resetFontStyle();
          },
        ),
      ],
    );
  }
}
