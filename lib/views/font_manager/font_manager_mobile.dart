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
          "Theme",
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: [
          buildTogglePreview(context),
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

  SpIconButton buildSearch(BuildContext context) {
    return SpIconButton(
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

  SpPopupMenuButton buildFontInfo() {
    return SpPopupMenuButton(
      items: (BuildContext context) {
        String provider = "https://fonts.google.com";
        return [
          SpPopMenuItem(
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
            title: "Provider",
            subtitle: provider,
            onPressed: () async {
              if (await canLaunch(provider)) {
                launch(provider);
              }
            },
          ),
        ];
      },
      builder: (void Function() callback) {
        return SpIconButton(
          icon: Icon(Icons.info),
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
      icon: Icon(Icons.preview),
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

class FontManagerSearchDelegate extends SearchDelegate {
  final List<String> fonts;
  final void Function(String fontFamily) onPressed;

  FontManagerSearchDelegate({
    required this.fonts,
    required this.onPressed,
  });

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return SpPopButton();
  }

  @override
  void showResults(BuildContext context) {}

  @override
  Widget buildResults(BuildContext context) {
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> _suggestions = suggestions();
    return ListView.builder(
      itemCount: _suggestions.length,
      itemBuilder: (context, index) {
        String item = _suggestions[index];
        return ListTile(
          title: Text(item),
          onTap: () async {
            onPressed(item);
            await Future.delayed(ConfigConstant.fadeDuration);
            close(context, _suggestions);
          },
        );
      },
    );
  }

  List<String> suggestions() {
    return fonts.where((element) {
      return element.toLowerCase().contains(query.trim().toLowerCase());
    }).toList();
  }
}
