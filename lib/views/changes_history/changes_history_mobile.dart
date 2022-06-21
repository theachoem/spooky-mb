part of changes_history_view;

class _ChangesHistoryMobile extends StatelessWidget {
  final ChangesHistoryViewModel viewModel;
  const _ChangesHistoryMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
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
          actions: [
            buildDeleteChangeButton(),
            SpIconButton(
              icon: const Icon(CommunityMaterialIcons.select),
              onPressed: () {
                viewModel.toggleEditing();
              },
            ),
          ],
          title: buildAppBarTitle(context),
        ),
        body: buildListView(context),
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

  Widget buildAppBarTitle(BuildContext context) {
    return SpCrossFade(
      showFirst: !viewModel.editing,
      alignment: viewModel.editing ? Alignment.center : Alignment.center,
      firstChild: const SpAppBarTitle(fallbackRouter: SpRouter.changesHistory),
      secondChild: ValueListenableBuilder(
        valueListenable: viewModel.selectedNotifier,
        builder: (context, child, value) {
          return Text(
            viewModel.selectedNotifier.value.length.toString(),
            style: Theme.of(context).appBarTheme.titleTextStyle,
          );
        },
      ),
    );
  }

  Widget buildDeleteChangeButton() {
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
                  viewModel.delele();
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

  Widget buildListView(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(height: 0),
      itemCount: viewModel.story.changes.length,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (_, index) {
        StoryContentDbModel content = viewModel.story.changes[index];
        int id = content.id;
        bool latest = index == viewModel.story.changes.length - 1;
        bool draft = content.draft == true;
        return SpPopupMenuButton(
          dx: MediaQuery.of(context).size.width,
          items: (context) => [
            SpPopMenuItem(
              title: "View Story",
              onPressed: () {
                Navigator.of(context).pushNamed(
                  SpRouter.contentReader.path,
                  arguments: ContentReaderArgs(content: content),
                );
              },
            ),
            if (!viewModel.editing && !latest)
              SpPopMenuItem(
                title: "Select",
                onPressed: () {
                  addItem(id, latest);
                  viewModel.toggleEditing();
                },
              ),
            if (!latest)
              SpPopMenuItem(
                title: "Restore this version",
                onPressed: () {
                  viewModel.onRestorePressed(content);
                  Navigator.of(context).maybePop();
                },
              ),
          ],
          builder: (callback) {
            return ListTile(
              onLongPress: () {
                if (viewModel.editing) {
                  toggleItem(id, latest);
                } else {
                  viewModel.toggleEditing();
                  addItem(id, latest);
                }
              },
              title: RichText(
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
                    if (draft)
                      const WidgetSpan(
                        child: SpSmallChip(label: "Draft"),
                        alignment: PlaceholderAlignment.middle,
                      ),
                    TextSpan(
                      text: " ${content.title ?? "No title"}" * 2,
                    )
                  ],
                ),
              ),
              subtitle: buildSubtitle(content, context),
              trailing: SpCrossFade(
                showFirst: !viewModel.editing,
                firstChild: const SizedBox(
                  height: ConfigConstant.objectHeight1,
                  child: Icon(Icons.more_vert),
                ),
                secondChild: buildCheckBox(content, id, latest: latest),
              ),
              onTap: () {
                if (viewModel.editing) {
                  toggleItem(id, latest);
                } else {
                  callback();
                }
              },
            );
          },
        );
      },
    );
  }

  Widget buildCheckBox(
    StoryContentDbModel content,
    int id, {
    bool latest = false,
  }) {
    return ValueListenableBuilder<Set<int>>(
      valueListenable: viewModel.selectedNotifier,
      builder: (context, selectedItems, child) {
        bool selected = viewModel.selectedNotifier.value.contains(content.id);
        return Checkbox(
          onChanged: (bool? value) => toggleItem(id, latest),
          fillColor: !latest ? null : MaterialStateProperty.all(Theme.of(context).disabledColor),
          value: selected,
        );
      },
    );
  }

  void addItem(int id, bool latest) {
    if (latest) {
      showPreventEditLatestSnackbar();
      return;
    }
    Set<int> previous = {...viewModel.selectedNotifier.value};
    previous.add(id);
    viewModel.selectedNotifier.value = previous;
  }

  void showPreventEditLatestSnackbar() {
    MessengerService.instance.showSnackBar("Should not delete the latest one!");
  }

  void toggleItem(int id, bool latest) {
    if (latest) {
      showPreventEditLatestSnackbar();
      return;
    }
    Set<int> previous = {...viewModel.selectedNotifier.value};
    if (previous.contains(id)) {
      previous.remove(id);
    } else {
      previous.add(id);
    }
    viewModel.selectedNotifier.value = previous;
  }

  Widget? buildSubtitle(StoryContentDbModel content, BuildContext context) {
    String date = DateFormatHelper.dateTimeFormat().format(content.createdAt);
    return Text(
      "Created at $date",
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontWeight: FontWeight.w500),
    );
  }
}
