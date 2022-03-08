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
        leading: const SpPopButton(),
        title: Text(
          "Font Manager",
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: [
          buildSearch(context),
          buildMoreButton(Icons.settings),
        ],
      ),
      body: ListView.builder(
        itemCount: widget.viewModel.fonts.length,
        itemBuilder: (context, index) {
          final font = widget.viewModel.fonts[index];
          String name = font.key;
          return FontTile(
            fontFamily: name,
            onFontUpdated: () {},
          );
        },
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
            fonts: widget.viewModel.fonts.map((e) => e.key).toList(),
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

            if (await canLaunch(queryUri.toString())) {
              launch(
                queryUri.toString(),
                forceSafariVC: true,
              );
            }
          },
        ),
        ListTile(
          title: const Text("Provider"),
          subtitle: const Text("font.google.com"),
          trailing: const Icon(Icons.keyboard_arrow_right),
          onTap: () async {
            if (await canLaunch(provider)) {
              launch(
                provider,
                forceSafariVC: true,
              );
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                Icons.info,
                size: ConfigConstant.iconSize1,
                color: M3Color.of(context).primary,
              ),
              const SizedBox(width: ConfigConstant.margin0),
              Expanded(
                child: Text(
                  "These will be opened on browser",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: M3Color.of(context).primary),
                ),
              ),
            ],
          ),
        )
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

            FontWeight? fontWeight = await showConfirmationDialog(
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
            );
            if (fontWeight != null) {
              context.read<ThemeProvider>().updateFontWeight(fontWeight);
            }
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
