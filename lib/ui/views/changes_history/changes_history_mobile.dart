part of changes_history_view;

class _ChangesHistoryMobile extends StatelessWidget {
  final ChangesHistoryViewModel viewModel;
  const _ChangesHistoryMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(
        leading: SpPopButton(),
        title: Text(
          "Changes History",
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: buildListView(context),
    );
  }

  Widget buildListView(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(height: 0),
      itemCount: viewModel.story.changes.length,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (_context, index) {
        StoryContentModel content = viewModel.story.changes[index];
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
              title: Text(
                content.id,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: buildEntitySubtitle(content),
              trailing: const Icon(Icons.more_vert),
              onTap: () {
                callback();
              },
            );
          },
        );
      },
    );
  }

  Widget? buildEntitySubtitle(StoryContentModel content) {
    String date = DateFormatHelper.dateTimeFormat().format(content.createdAt);
    return Text("Created at $date");
  }
}
