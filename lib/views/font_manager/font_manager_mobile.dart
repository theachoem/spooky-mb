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
        leading: SpPopButton(),
        title: Text(
          "Font Manager",
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: [
          buildSearch(context),
          buildMoreButton(),
        ],
      ),
      body: ListView.builder(
        itemCount: widget.viewModel.fonts.length,
        itemBuilder: (context, index) {
          final font = widget.viewModel.fonts[index];
          String name = font.key;
          return ListTile(
            title: Text(name),
            trailing: PreviewTrailing(fontFamily: name, context: context),
            onTap: () {
              context.read<ColorSeedProvider>().updateFont(name);
            },
          );
        },
      ),
    );
  }

  Widget buildSearch(BuildContext context) {
    return SpIconButton(
      tooltip: "Search fonts",
      icon: Icon(Icons.search),
      onPressed: () {
        showSearch(
          context: context,
          delegate: FontManagerSearchDelegate(
            fonts: widget.viewModel.fonts.map((e) => e.key).toList(),
            onPressed: (String fontFamily) {
              context.read<ColorSeedProvider>().updateFont(fontFamily);
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
    return SpSectionContents(
      headline: "Info",
      tiles: [
        ListTile(
          title: Text("Selected Font"),
          subtitle: Text(ThemeConfig.fontFamily),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () async {
            Uri? uri = Uri.tryParse(provider);
            if (uri == null) return;

            Uri queryUri = Uri(scheme: uri.scheme, host: uri.host, queryParameters: {
              "query": ThemeConfig.fontFamily,
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
          title: Text("Provider"),
          subtitle: Text("font.google.com"),
          trailing: Icon(Icons.keyboard_arrow_right),
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
    return SpSectionContents(
      headline: "Setting",
      tiles: [
        ListTile(
          title: Text("Font Weight"),
          trailing: Icon(Icons.keyboard_arrow_right),
          subtitle: Text(widget.viewModel.trimFontWeight(ThemeConfig.fontWeight)),
          onTap: () async {
            FontWeight? fontWeight = await showConfirmationDialog(
              context: context,
              title: "Font Weight",
              initialSelectedActionKey: ThemeConfig.fontWeight,
              actions: FontWeight.values.map((e) {
                return AlertDialogAction(
                  key: e,
                  isDefaultAction: e == ThemeConfig.fontWeight,
                  label: widget.viewModel.trimFontWeight(e),
                );
              }).toList(),
            );
            if (fontWeight != null) {
              context.read<ColorSeedProvider>().updateFontWeight(fontWeight);
            }
          },
        ),
        ListTile(
          title: Text("Restore Default Style"),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {
            context.read<ColorSeedProvider>().resetFontStyle();
          },
        ),
      ],
    );
  }
}