part of backup_histories_manager_view;

class _BackupHistoriesManagerMobile extends StatelessWidget {
  final BackupHistoriesManagerViewModel viewModel;
  const _BackupHistoriesManagerMobile(this.viewModel);

  void showPreventEditLatestSnackbar() {
    MessengerService.instance.showSnackBar("Should not delete the latest one!");
  }

  void toggleItem(String id, bool latest) {
    if (latest) {
      showPreventEditLatestSnackbar();
      return;
    }
    Set<String> previous = {...viewModel.selectedNotifier.value};
    if (previous.contains(id)) {
      previous.remove(id);
    } else {
      previous.add(id);
    }
    viewModel.selectedNotifier.value = previous;
  }

  void addItem(String id, bool latest) {
    if (latest) {
      showPreventEditLatestSnackbar();
      return;
    }
    Set<String> previous = {...viewModel.selectedNotifier.value};
    previous.add(id);
    viewModel.selectedNotifier.value = previous;
  }

  @override
  Widget build(BuildContext context) {
    List<CloudFileModel> files = viewModel.list?.files ?? [];
    return WillPopScope(
      onWillPop: () async {
        if (viewModel.editing) {
          viewModel.toggleEditing();
          return false;
        } else {
          bool backable = !viewModel.editing;
          return backable;
        }
      },
      child: Scaffold(
        appBar: MorphingAppBar(
          leading: buildPopButton(),
          title: const SpAppBarTitle(fallbackRouter: SpRouter.backupHistoriesManager),
          actions: [
            buildDeleteHistoriesButton(),
            SpIconButton(
              icon: const Icon(CommunityMaterialIcons.select),
              onPressed: () {
                viewModel.toggleEditing();
              },
            ),
          ],
        ),
        body: ValueListenableBuilder<bool>(
          valueListenable: viewModel.loadingNotifier,
          child: ListView.builder(
            itemCount: files.length,
            itemBuilder: (context, index) {
              final file = files[index];
              final metaData = BackupsMetadata.fromFileName(file.fileName ?? "");

              String title = metaData?.deviceModel ?? file.id;
              String? subtitle = metaData?.displayCreatedAt;
              bool latest = index == 0;
              String id = file.id;

              return ListTile(
                onLongPress: () {
                  if (viewModel.editing) {
                    toggleItem(file.id, index == 0);
                  } else {
                    viewModel.toggleEditing();
                    addItem(file.id, index == 0);
                  }
                },
                onTap: () {
                  toggleItem(file.id, index == 0);
                },
                title: buildTitle(context, latest, title),
                subtitle: Text(subtitle ?? "Unsupported file"),
                trailing: SpCrossFade(
                  showFirst: !viewModel.editing,
                  firstChild: const SizedBox(
                    height: ConfigConstant.objectHeight1,
                    child: Icon(Icons.more_vert),
                  ),
                  secondChild: buildCheckBox(id: id, latest: latest),
                ),
              );
            },
          ),
          builder: (context, loading, child) {
            return !loading ? child! : const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  RichText buildTitle(BuildContext context, bool latest, String title) {
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        text: "",
        style: M3TextTheme.of(context).titleMedium,
        children: [
          if (latest)
            WidgetSpan(
              child: Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: SpSmallChip(
                  label: "Latest",
                  color: M3Color.of(context).tertiary,
                ),
              ),
              alignment: PlaceholderAlignment.middle,
            ),
          TextSpan(
            text: title,
          )
        ],
      ),
    );
  }

  Widget buildPopButton() {
    return SpAnimatedIcons(
      showFirst: !viewModel.editing,
      firstChild: const SpPopButton(
        key: ValueKey("PopButtonOnViewing"),
      ),
      secondChild: SpIconButton(
        icon: const Icon(Icons.clear),
        key: const ValueKey("PopButtonOnEditing"),
        onPressed: () {
          viewModel.toggleEditing();
        },
      ),
    );
  }

  Widget buildDeleteHistoriesButton() {
    return ValueListenableBuilder(
      valueListenable: viewModel.selectedNotifier,
      builder: (context, child, value) {
        return SpAnimatedIcons(
          showFirst: viewModel.editing && viewModel.selectedNotifier.value.isNotEmpty,
          firstChild: SpIconButton(
            icon: const Icon(Icons.delete),
            key: const ValueKey(Icons.delete),
            onPressed: () async {
              OkCancelResult result = await showOkCancelAlertDialog(
                context: context,
                title: "Are you sure to delete?",
                message: "${viewModel.selectedNotifier.value.length} selected",
                okLabel: "Delete",
                isDestructiveAction: true,
              );

              switch (result) {
                case OkCancelResult.ok:
                  MessengerService.instance.showLoading(
                    future: () => viewModel.deleteSelected().then((value) => 1),
                    context: context,
                    debugSource: "_BackupHistoriesManagerMobile#buildDeleteHistoriesButton",
                  );
                  break;
                case OkCancelResult.cancel:
                  break;
              }
            },
          ),
          secondChild: const SizedBox.shrink(
            key: ValueKey("SizeBox"),
          ),
        );
      },
    );
  }

  Widget buildCheckBox({
    required String id,
    required bool latest,
  }) {
    return ValueListenableBuilder<Set<String>>(
      valueListenable: viewModel.selectedNotifier,
      builder: (context, selectedItems, child) {
        bool selected = viewModel.selectedNotifier.value.contains(id);
        return Checkbox(
          onChanged: (bool? value) => toggleItem(id, latest),
          fillColor: !latest ? null : MaterialStateProperty.all(Theme.of(context).disabledColor),
          value: selected,
        );
      },
    );
  }
}
