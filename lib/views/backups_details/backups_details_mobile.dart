part of backups_details_view;

class _BackupsDetailsMobile extends StatelessWidget {
  final BackupsDetailsViewModel viewModel;
  const _BackupsDetailsMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(
        leading: const SpPopButton(),
        title: const SpAppBarTitle(fallbackRouter: SpRouter.backupsDetails),
        actions: [
          buildActionButtons(context),
        ],
      ),
      bottomNavigationBar: SpSingleButtonBottomNavigation(
        show: viewModel.backup != null,
        buttonLabel: tr("button.restore"),
        onTap: () {
          if (viewModel.backup == null) return;
          viewModel.destination.restore(
            viewModel.backup!,
            context,
          );
        },
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: viewModel.loadingNotifier,
        child: ListView(
          physics: const ScrollPhysics(),
          children: [
            ...viewModel.backup?.tables.entries.map((e) {
                  dynamic value = e.value;
                  return buildTableTile(
                    tableName: e.key,
                    rowsCount: value is List ? value.length : 0,
                    context: context,
                    element: e,
                  );
                }) ??
                []
          ],
        ),
        builder: (context, loading, child) {
          return !loading ? child! : const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget buildActionButtons(BuildContext context) {
    return SpPopupMenuButton(
      fromAppBar: true,
      items: (context) {
        return [
          SpPopMenuItem(
            title: "Select version",
            trailingIconData: Icons.keyboard_arrow_right,
            onPressed: () {
              selectVersion(context);
            },
          ),
          SpPopMenuItem(
            title: "Manage versions",
            trailingIconData: Icons.keyboard_arrow_right,
            onPressed: () async {
              await Navigator.of(context).pushNamed(
                SpRouter.backupHistoriesManager.path,
                arguments: BackupHistoriesManagerArgs(destination: viewModel.destination),
              );
              // ignore: use_build_context_synchronously
              Navigator.maybePop(context, true);
            },
          ),
        ];
      },
      builder: (callback) {
        return SpIconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: callback,
        );
      },
    );
  }

  Future<void> selectVersion(BuildContext context) async {
    Iterable<CloudFileTuple> result = viewModel.cloudFiles.reversed;

    String? cloudId = await showConfirmationDialog(
      context: context,
      title: "Select a version",
      initialSelectedActionKey: viewModel.selectCloudFileId,
      actions: result.map((e) {
        String cloudFileId = e.cloudFile.id;
        return AlertDialogAction(
          key: cloudFileId,
          label: e.metadata.displayCreatedAt,
          isDefaultAction: cloudFileId == viewModel.selectCloudFileId,
        );
      }).toList(),
    );

    if (cloudId != null) {
      viewModel.setCurrentCloudVersion(cloudId);
    }
  }

  // TODO: improve this
  void onReview(MapEntry<String, dynamic> e, value, BuildContext context) {
    if (e.key == "stories" && value is List) {
      List<StoryDbModel> stories = [];

      for (dynamic json in value) {
        try {
          StoryDbModel story = StoryDbModel.fromJson(json);
          stories.add(story);
        } catch (e) {
          if (kDebugMode) {
            print("ERROR: buildTableTile $e");
          }
        }
      }

      BottomSheetService.instance.showScrollableSheet(
        context: App.navigatorKey.currentContext ?? context,
        title: e.key.capitalize,
        builder: (context, controller) {
          return SpStoryList(
            overridedLayout: SpListLayoutType.timeline,
            stories: stories,
            viewOnly: true,
            controller: controller,
            onRefresh: () async {},
          );
        },
      );
    }
  }

  ListTile buildTableTile({
    required String tableName,
    required int rowsCount,
    required BuildContext context,
    required MapEntry<String, dynamic> element,
  }) {
    IconData iconData;
    void Function()? review;

    switch (tableName) {
      case "stories":
        iconData = Icons.people;
        review = () => onReview(element, element.value, context);
        break;
      default:
        iconData = CommunityMaterialIcons.table;
    }

    return ListTile(
      leading: SizedBox(width: 44, height: 44, child: Icon(iconData)),
      contentPadding: const EdgeInsets.all(ConfigConstant.margin2),
      title: Text(tableName.capitalize),
      isThreeLine: review != null,
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$rowsCount documents"),
          if (review != null) ConfigConstant.sizedBoxH1,
          if (review != null)
            SpButton(
              label: tr("button.review"),
              onTap: review,
              backgroundColor: M3Color.of(context).secondary,
              foregroundColor: M3Color.of(context).onSecondary,
            )
        ],
      ),
      onTap: review,
    );
  }
}
