part of restore_view;

class _RestoreMobile extends StatelessWidget {
  final RestoreViewModel viewModel;
  const _RestoreMobile(this.viewModel);

  double get expandedHeight => 200;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: buildBottomNavigation(context),
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
          return Stack(
            children: [
              buildYearsTile(context: context, item: e),
              if (index == 0)
                Container(
                  height: 4.0,
                  width: double.infinity,
                  color: M3Color.of(context).background,
                ),
            ],
          );
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

  Widget buildYearsTile({required BuildContext context, required MapEntry<String, List<CloudFileModel>> item}) {
    return TweenAnimationBuilder<int>(
      duration: ConfigConstant.duration,
      tween: IntTween(begin: 0, end: 1),
      builder: (context, value, child) {
        return AnimatedOpacity(
          opacity: value == 1 ? 1.0 : 0.0,
          duration: ConfigConstant.duration,
          child: ExpansionTile(
            title: Text("Stories of ${item.key}"),
            children: List.generate(item.value.length, (index) {
              final e = item.value[index];
              BackupDisplayModel display = BackupDisplayModel.fromCloudModel(e);
              return SpPopupMenuButton(
                dxGetter: (dx) => MediaQuery.of(context).size.width,
                items: (context) => buildItems(context, e, index != 0),
                builder: (callback) {
                  return ListTile(
                    title: Text("Uploaded at " + (display.displayDate ?? display.fileName)),
                    subtitle: display.displayTime != null ? Text(display.displayTime!) : null,
                    onTap: () => callback(),
                    trailing: Icon(Icons.more_vert),
                  );
                },
              );
            }),
          ),
        );
      },
    );
  }

  List<SpPopMenuItem> buildItems(
    BuildContext context,
    CloudFileModel e,
    bool canDelete,
  ) {
    return [
      if (canDelete)
        SpPopMenuItem(
          title: "Delete",
          leadingIconData: Icons.delete,
          onPressed: () => viewModel.delete(context, e),
        ),
      SpPopMenuItem(
        title: "Restore",
        leadingIconData: Icons.restore,
        onPressed: () => viewModel.restore(context, e),
      ),
      SpPopMenuItem(
        title: "View",
        leadingIconData: Icons.list,
        onPressed: () async {
          BackupModel? result =
              await MessengerService.instance.showLoading(future: () => viewModel.download(e), context: context);
          if (result == null) return;
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            isDismissible: true,
            useRootNavigator: true,
            builder: (context) {
              return DraggableScrollableSheet(
                expand: false,
                builder: (context, controller) {
                  return Scaffold(
                    body: StoryList(
                      viewOnly: true,
                      controller: controller,
                      onRefresh: () async {},
                      stories: result.stories,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    ];
  }

  Widget buildBottomNavigation(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SpButton(
            label: "Done",
            onTap: () {
              Navigator.of(context).pushNamedAndRemoveUntil(SpRouter.main.path, (_) => false);
            },
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).padding.bottom + ConfigConstant.margin2,
        ),
      ],
    );
  }

  MorphingSliverAppBar buildAppBar(BuildContext context) {
    return MorphingSliverAppBar(
      expandedHeight: expandedHeight,
      backgroundColor: M3Color.of(context).background,
      leading: SpPopButton(),
      pinned: true,
      floating: true,
      stretch: true,
      title: Text(""),
      elevation: Theme.of(context).appBarTheme.elevation,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.none,
        background: TweenAnimationBuilder<int>(
          duration: ConfigConstant.fadeDuration,
          tween: IntTween(begin: 0, end: 1),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(top: 72.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Restore",
                  style: Theme.of(context).appBarTheme.titleTextStyle,
                  textAlign: TextAlign.center,
                ),
                ConfigConstant.sizedBoxH1,
                Text(
                  "Connect with a Cloud Storage to restore your stories.",
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          builder: (context, value, child) {
            return AnimatedOpacity(
              opacity: value == 1 ? 1.0 : 0.0,
              duration: ConfigConstant.fadeDuration,
              child: child,
            );
          },
        ),
      ),
      actions: [
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
