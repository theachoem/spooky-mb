part of restore_view;

class _RestoreMobile extends StatelessWidget {
  final RestoreViewModel viewModel;
  const _RestoreMobile(this.viewModel);

  double get expandedHeight => 200;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: viewModel.showSkipButton ? buildBottomNavigation(context) : null,
      extendBody: true,
      body: RefreshIndicator(
        displacement: expandedHeight / 2,
        onRefresh: () => viewModel.load(),
        child: CustomScrollView(
          slivers: [
            buildAppBar(context),
            SliverPadding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + kToolbarHeight + 16.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  SpSectionsTiles.divide(
                    showTopDivider: true,
                    context: context,
                    sections: [
                      buildCloudServices(),
                      if (viewModel.fileList != null) buildBackups(context),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  SpSectionContents buildBackups(BuildContext context) {
    return SpSectionContents(
      headline: "Backups",
      tiles: List.generate(
        viewModel.groupByYear?.entries.length ?? 0,
        (index) {
          final e = viewModel.groupByYear!.entries.elementAt(index);
          return buildYearsTile(context: context, items: e);
        },
      ),
    );
  }

  SpSectionContents buildCloudServices() {
    return SpSectionContents(
      headline: "Cloud Service",
      tiles: [
        GoogleAccountTile(
          onSignOut: () {
            viewModel.load();
          },
          onSignIn: () {
            viewModel.load();
          },
        ),
      ],
    );
  }

  Widget buildYearsTile({
    required BuildContext context,
    required MapEntry<String, List<CloudFileModel>> items,
  }) {
    List<BackupDisplayModel> displayModels = items.value.map((e) => BackupDisplayModel.fromCloudModel(e)).toList();
    displayModels.sort((a, b) => (a.createAt != null ? b.createAt?.compareTo(a.createAt!) : -1) ?? -1);
    if (displayModels.isEmpty) return const SizedBox.shrink();

    CloudFileModel cloudBackup = items.value.first;
    BackupDisplayModel displayBackup = displayModels.first;

    return TweenAnimationBuilder<int>(
      duration: ConfigConstant.duration,
      tween: IntTween(begin: 0, end: 1),
      builder: (context, value, child) {
        return AnimatedOpacity(
          opacity: value == 1 ? 1.0 : 0.0,
          duration: ConfigConstant.duration,
          child: SpPopupMenuButton(
            dxGetter: (dx) => MediaQuery.of(context).size.width,
            items: (context) => buildItems(
              context: context,
              cloudBackup: cloudBackup,
              displayBackup: displayBackup,
              items: items.value,
              displayModels: displayModels,
            ),
            builder: (callback) {
              return ListTile(
                onTap: callback,
                trailing: const Icon(Icons.cloud_done),
                title: Text("Stories of ${items.key}"),
                subtitle: Text("Uploaded at " + (displayBackup.displayDateTime ?? displayBackup.fileName)),
              );
            },
          ),
        );
      },
    );
  }

  List<SpPopMenuItem> buildItems({
    required BuildContext context,
    required CloudFileModel cloudBackup,
    required BackupDisplayModel displayBackup,
    required List<CloudFileModel> items,
    required List<BackupDisplayModel> displayModels,
  }) {
    return [
      SpPopMenuItem(
        title: "Restore",
        titleStyle: TextStyle(color: viewModel.getCache(cloudBackup) != null ? M3Color.of(context).tertiary : null),
        leadingIconData: Icons.restore,
        onPressed: () => viewModel.restore(context, cloudBackup, displayBackup),
      ),
      SpPopMenuItem(
        title: "View",
        leadingIconData: Icons.list,
        titleStyle: TextStyle(color: viewModel.getCache(cloudBackup) == null ? M3Color.of(context).tertiary : null),
        onPressed: () async {
          BackupModel? result = await MessengerService.instance
              .showLoading(future: () => viewModel.download(cloudBackup), context: context);
          if (result == null) return;
          BottomSheetService.instance.showScrollableSheet(
            context: context,
            title: displayBackup.createAt?.year.toString() ?? "Stories",
            builder: (context, controller) {
              return StoryList(
                viewOnly: true,
                controller: controller,
                onRefresh: () async {},
                stories: result.stories,
              );
            },
          );
        },
      ),
      SpPopMenuItem(
        title: "History",
        leadingIconData: Icons.subdirectory_arrow_right,
        onPressed: () async {
          BottomSheetService.instance.showScrollableSheet(
            context: context,
            title: "History",
            builder: (BuildContext _, ScrollController controller) {
              return ListView.builder(
                controller: controller,
                itemCount: displayModels.length,
                itemBuilder: (_, index) {
                  CloudFileModel backup = items[index];
                  BackupDisplayModel display = displayModels[index];
                  return SpPopupMenuButton(
                    dxGetter: (dx) => MediaQuery.of(context).size.width,
                    items: (context) => buildChildItems(
                      context: context,
                      cloudBackup: backup,
                      displayBackup: display,
                      items: items,
                      displayModels: displayModels,
                      canDelete: index != 0,
                    ),
                    builder: (callback) {
                      String title = "Backup ${index + 1}";
                      return ListTile(
                        onTap: callback,
                        title: RichText(
                          text: TextSpan(
                            text: title + " ",
                            style: M3TextTheme.of(context).titleMedium,
                            children: [
                              if (index == 0)
                                const WidgetSpan(
                                  child: SpSmallChip(label: "Latest"),
                                  alignment: PlaceholderAlignment.middle,
                                ),
                            ],
                          ),
                        ),
                        subtitle: Text("Uploaded at " + display.displayDateTime.toString()),
                        trailing: const Icon(Icons.more_vert),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    ];
  }

  List<SpPopMenuItem> buildChildItems({
    required BuildContext context,
    required CloudFileModel cloudBackup,
    required BackupDisplayModel displayBackup,
    required List<CloudFileModel> items,
    required List<BackupDisplayModel> displayModels,
    required bool canDelete,
  }) {
    return [
      if (canDelete)
        SpPopMenuItem(
          title: "Delete",
          leadingIconData: Icons.delete,
          titleStyle: TextStyle(color: M3Color.of(context).error),
          onPressed: () async {
            await viewModel.delete(context, cloudBackup);
            Navigator.of(context).pop();
          },
        ),
      SpPopMenuItem(
        title: "Restore",
        titleStyle: TextStyle(color: viewModel.getCache(cloudBackup) != null ? M3Color.of(context).tertiary : null),
        leadingIconData: Icons.restore,
        onPressed: () => viewModel.restore(context, cloudBackup, displayBackup),
      ),
      SpPopMenuItem(
        title: "View",
        leadingIconData: Icons.list,
        titleStyle: TextStyle(color: viewModel.getCache(cloudBackup) == null ? M3Color.of(context).tertiary : null),
        onPressed: () async {
          BackupModel? result = await MessengerService.instance
              .showLoading(future: () => viewModel.download(cloudBackup), context: context);
          if (result == null) return;
          BottomSheetService.instance.showScrollableSheet(
            context: context,
            title: displayBackup.createAt?.year.toString() ?? "Stories",
            builder: (context, controller) {
              return StoryList(
                viewOnly: true,
                controller: controller,
                onRefresh: () async {},
                stories: result.stories,
              );
            },
          );
        },
      ),
    ];
  }

  Widget buildBottomNavigation(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: viewModel.showSkipNotifier,
      builder: (context, value, child) {
        return SpSingleButtonBottomNavigation(
          buttonLabel: "Done",
          show: !viewModel.showSkipNotifier.value,
          onTap: () {
            Navigator.of(context).pushNamedAndRemoveUntil(SpRouter.main.path, (_) => false);
          },
        );
      },
    );
  }

  Widget buildAppBar(BuildContext context) {
    return SpExpandedAppBar(
      expandedHeight: expandedHeight,
      backgroundColor: M3Color.of(context).background,
      actions: [
        if (viewModel.showSkipButton)
          ValueListenableBuilder(
            valueListenable: viewModel.showSkipNotifier,
            builder: (context, value, child) {
              return SpCrossFade(
                showFirst: !viewModel.showSkipNotifier.value,
                firstChild: const SizedBox.shrink(),
                secondChild: Center(
                  child: SpButton(
                    label: "Skip",
                    backgroundColor: Colors.transparent,
                    foregroundColor: Theme.of(context).appBarTheme.titleTextStyle?.color,
                    onTap: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(SpRouter.main.path, (_) => false);
                    },
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
