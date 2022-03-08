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
          actions: [buildDeleteChangeButton()],
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
      firstChild: const SpAppBarTitle(),
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
                message: viewModel.selectedNotifier.value.length.toString() + " selected",
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
      itemBuilder: (_context, index) {
        StoryContentModel content = viewModel.story.changes[index];
        String id = content.id;
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
            if (!viewModel.editing)
              SpPopMenuItem(
                title: "Select",
                onPressed: () {
                  addItem(id);
                  viewModel.toggleEditing();
                },
              ),
            if (viewModel.story.changes.length - 1 != index)
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
                  toggleItem(id);
                } else {
                  viewModel.toggleEditing();
                  addItem(id);
                }
              },
              title: Text(
                content.title ?? "No title",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: buildSubtitle(content, context),
              trailing: SpCrossFade(
                showFirst: !viewModel.editing,
                firstChild: const SizedBox(
                  height: ConfigConstant.objectHeight1,
                  child: Icon(Icons.more_vert),
                ),
                secondChild: buildCheckBox(content, id),
              ),
              onTap: () {
                if (viewModel.editing) {
                  toggleItem(id);
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

  Widget buildCheckBox(StoryContentModel content, String id) {
    return ValueListenableBuilder<Set<String>>(
      valueListenable: viewModel.selectedNotifier,
      builder: (context, selectedItems, child) {
        bool selected = viewModel.selectedNotifier.value.contains(content.id);
        return Checkbox(
          onChanged: (bool? value) => toggleItem(id),
          value: selected,
        );
      },
    );
  }

  void addItem(String id) {
    Set<String> previous = {...viewModel.selectedNotifier.value};
    previous.add(id);
    viewModel.selectedNotifier.value = previous;
  }

  void toggleItem(String id) {
    Set<String> previous = {...viewModel.selectedNotifier.value};
    if (previous.contains(id)) {
      previous.remove(id);
    } else {
      previous.add(id);
    }
    viewModel.selectedNotifier.value = previous;
  }

  Widget? buildSubtitle(StoryContentModel content, BuildContext context) {
    String date = DateFormatHelper.dateTimeFormat().format(content.createdAt);
    return Text(
      "Created at $date",
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontWeight: FontWeight.w500),
    );
  }
}
