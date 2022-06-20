part of backups_details_view;

class _BackupsDetailsMobile extends StatelessWidget {
  final BackupsDetailsViewModel viewModel;
  const _BackupsDetailsMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      appBar: MorphingAppBar(
        title: const SpAppBarTitle(fallbackRouter: SpRouter.backupsDetails),
        actions: [
          buildActionButtons(context),
        ],
      ),
      bottomNavigationBar: SpSingleButtonBottomNavigation(
        show: viewModel.backup != null,
        buttonLabel: "Restore",
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
                    onReview: () => onReview(e, value, context),
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

  SpIconButton buildActionButtons(BuildContext context) {
    return SpIconButton(
      icon: const Icon(Icons.more_vert),
      onPressed: () async {
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
      },
    );
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
          return StoryList(
            viewOnly: true,
            controller: controller,
            onRefresh: () async {},
            stories: stories,
            overridedLayout: ListLayoutType.single,
          );
        },
      );
    }
  }

  ListTile buildTableTile({
    required String tableName,
    required int rowsCount,
    required BuildContext context,
    required void Function() onReview,
  }) {
    return ListTile(
      leading: const SizedBox(width: 44, height: 44, child: Icon(Icons.people)),
      contentPadding: const EdgeInsets.all(ConfigConstant.margin2),
      title: Text(tableName.capitalize),
      isThreeLine: true,
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$rowsCount documents"),
          ConfigConstant.sizedBoxH1,
          SpButton(
            label: "Review",
            onTap: () => onReview(),
            backgroundColor: M3Color.of(context).secondary,
            foregroundColor: M3Color.of(context).onSecondary,
          )
        ],
      ),
      onTap: () => onReview(),
    );
  }
}
