part of font_manager_view;

class _FontManagerMobile extends StatelessWidget {
  final FontManagerViewModel viewModel;
  const _FontManagerMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(
        leading: SpPopButton(),
        title: Text(
          "Font Manager",
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: [
          buildTogglePreview(context),
          buildFontWeightButton(context),
          buildFontInfo(),
          buildSearch(context),
        ],
      ),
      body: ListView.builder(
        itemCount: viewModel.fonts.length,
        itemBuilder: (context, index) {
          final font = viewModel.fonts[index];
          String name = font.key;
          return ListTile(
            title: Text(name),
            trailing: SpCrossFade(
              duration: ConfigConstant.duration,
              showFirst: name == ThemeConfig.fontFamily,
              firstChild: Icon(Icons.check, color: M3Color.of(context).primary),
              secondChild: SizedBox.square(dimension: ConfigConstant.iconSize2),
            ),
            subtitle: viewModel.preview ? Text("Preview", style: font.value()) : null,
            onTap: () {
              context.read<ColorSeedProvider>().updateFont(name);
            },
          );
        },
      ),
    );
  }

  Widget buildFontWeightButton(BuildContext context) {
    return SpIconButton(
      tooltip: "Font Weight",
      icon: Icon(Icons.line_weight),
      onPressed: () async {
        FontWeight? fontWeight = await showConfirmationDialog(
          context: context,
          title: "Font Weight",
          initialSelectedActionKey: ThemeConfig.fontWeight,
          actions: FontWeight.values.map((e) {
            return AlertDialogAction(
              key: e,
              isDefaultAction: e == ThemeConfig.fontWeight,
              label: e.toString().split(".").last,
            );
          }).toList(),
        );
        if (fontWeight != null) {
          context.read<ColorSeedProvider>().updateFontWeight(fontWeight);
        }
      },
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
            fonts: viewModel.fonts.map((e) => e.key).toList(),
            onPressed: (String fontFamily) {
              context.read<ColorSeedProvider>().updateFont(fontFamily);
            },
          ),
        );
      },
    );
  }

  Widget buildFontInfo() {
    return SpPopupMenuButton(
      items: (BuildContext context) {
        String provider = "https://fonts.google.com";
        return [
          SpPopMenuItem(
            leadingIconData: Icons.font_download,
            title: "Current font",
            subtitle: ThemeConfig.fontFamily,
            onPressed: () async {
              Uri? uri = Uri.tryParse(provider);
              if (uri == null) return;

              Uri queryUri = Uri(scheme: uri.scheme, host: uri.host, queryParameters: {
                "query": ThemeConfig.fontFamily,
              });

              if (await canLaunch(queryUri.toString())) {
                launch(queryUri.toString());
              }
            },
          ),
          SpPopMenuItem(
            leadingIconData: Icons.web,
            title: "Provider",
            subtitle: provider,
            onPressed: () async {
              if (await canLaunch(provider)) {
                launch(provider);
              }
            },
          ),
          SpPopMenuItem(
            leadingIconData: Icons.restore,
            title: "Reset Font Style",
            onPressed: () async {
              context.read<ColorSeedProvider>().resetFontStyle();
            },
          ),
        ];
      },
      builder: (void Function() callback) {
        return SpIconButton(
          tooltip: "Font info",
          icon: Icon(Icons.info_outline),
          onPressed: () {
            callback();
          },
        );
      },
    );
  }

  Widget buildTogglePreview(BuildContext context) {
    return SpIconButton(
      tooltip: "Preview Font",
      icon: Icon(Icons.preview_outlined),
      onPressed: () async {
        if (!viewModel.preview) {
          OkCancelResult response = await showOkCancelAlertDialog(
            context: context,
            title: "Are you sure to download?",
            message: "To preview, viewed fonts will be downloaded to device",
          );
          switch (response) {
            case OkCancelResult.ok:
              viewModel.togglePreview();
              break;
            case OkCancelResult.cancel:
              break;
          }
        } else {
          viewModel.togglePreview();
        }
      },
    );
  }
}
