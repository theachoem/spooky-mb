part of changes_history_view;

class _ChangesHistoryMobile extends StatelessWidget {
  final ChangesHistoryViewModel viewModel;
  const _ChangesHistoryMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool backable = !viewModel.editing;
        return backable;
      },
      child: Scaffold(
        appBar: MorphingAppBar(
          leading: SpAnimatedIcons(
            showFirst: !viewModel.editing,
            firstChild: SpPopButton(
              key: ValueKey("PopButtonOnViewing"),
            ),
            secondChild: SpIconButton(
              icon: Icon(Icons.clear),
              key: ValueKey("PopButtonOnEditing"),
              onPressed: () {
                viewModel.toggleEditing();
              },
            ),
          ),
          actions: [
            buildDeleteChangeButton(),
          ],
          title: SpCrossFade(
            showFirst: !viewModel.editing,
            firstChild: Text(
              "Changes History",
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
            secondChild: ValueListenableBuilder(
              valueListenable: viewModel.selectedNotifier,
              builder: (context, child, value) {
                return Text(
                  viewModel.selectedNotifier.value.length.toString(),
                  style: Theme.of(context).appBarTheme.titleTextStyle,
                );
              },
            ),
          ),
        ),
        body: buildListView(context),
      ),
    );
  }

  ValueListenableBuilder<Set<String>> buildDeleteChangeButton() {
    return ValueListenableBuilder(
      valueListenable: viewModel.selectedNotifier,
      builder: (context, child, value) {
        return SpAnimatedIcons(
          showFirst: viewModel.editing && viewModel.selectedNotifier.value.isNotEmpty,
          firstChild: SpIconButton(
            icon: Icon(Icons.delete),
            key: ValueKey(Icons.delete),
            onPressed: () {
              viewModel.onDeletePressed(
                viewModel.selectedNotifier.value.toList(),
              );
              context.router.popForced();
            },
          ),
          secondChild: SizedBox.shrink(
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
          items: [
            SpPopMenuItem(
              title: "View Story",
              onPressed: () {
                context.router.push(
                  route.ContentReader(content: content),
                );
              },
            ),
            if (viewModel.story.changes.length - 1 != index)
              SpPopMenuItem(
                title: "Restore this version",
                onPressed: () {
                  viewModel.onRestorePressed(content);
                  context.router.popForced();
                },
              ),
          ],
          builder: (callback) {
            return ListTile(
              onLongPress: () {
                if (viewModel.editing) return;
                viewModel.toggleEditing();
              },
              title: Text(
                content.title ?? "No title",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: buildSubtitle(content, context),
              trailing: SpCrossFade(
                showFirst: !viewModel.editing,
                firstChild: SizedBox(
                  height: ConfigConstant.objectHeight1,
                  child: Icon(Icons.more_vert),
                ),
                secondChild: buildCheckBox(content, id),
              ),
              onTap: () {
                if (viewModel.editing) {
                  onToggleItem(id);
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
          onChanged: (bool? value) => onToggleItem(id),
          value: selected,
        );
      },
    );
  }

  void onToggleItem(String id) {
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
      style: TextStyle(fontWeight: FontWeight.w500),
    );
  }
}
