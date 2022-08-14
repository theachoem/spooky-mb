part of font_manager_view;

class _FontManagerMobile extends StatefulWidget {
  final FontManagerViewModel viewModel;
  const _FontManagerMobile(this.viewModel);

  @override
  State<_FontManagerMobile> createState() => _FontManagerMobileState();
}

class _FontManagerMobileState extends State<_FontManagerMobile> with ScaffoldToggleSheetableMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: sheetScaffoldkey,
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
      tooltip: tr("button.search_fonts"),
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
        showTopDivider: true,
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
      headline: tr("section.info"),
      tiles: [
        ListTile(
          title: Text(tr("tile.selected_font.title")),
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
          title: Text(tr("tile.font_total.title")),
          subtitle: Text(
            tr("tile.font_total.subtitle", args: ["${widget.viewModel.allFonts.length}"]),
          ),
          trailing: const Icon(Icons.keyboard_arrow_right),
          onTap: () async {
            openWeb(provider);
          },
        ),
        ListTile(
          title: Text(tr("tile.provider.title")),
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
      headline: tr("section.setting"),
      tiles: [
        ListTile(
          title: Text(tr("tile.font_weight.title")),
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
              title: tr("tile.font_weight.title"),
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
          title: Text(tr("tile.restore_default_font.title")),
          trailing: const Icon(Icons.keyboard_arrow_right),
          onTap: () {
            context.read<ThemeProvider>().resetFontStyle();
          },
        ),
      ],
    );
  }
}
