part of 'story_changes_view.dart';

class _StoryChangesAdaptive extends StatelessWidget {
  const _StoryChangesAdaptive(this.viewModel);

  final StoryChangesViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: viewModel.originalStory?.allChanges?.length != null
            ? Text("Changes (${viewModel.originalStory?.allChanges?.length})")
            : const Text("Changes"),
      ),
      body: buildBody(),
      bottomNavigationBar: buildBottomNavigationBar(context),
    );
  }

  Widget buildBody() {
    if (viewModel.draftStory == null) return const Center(child: CircularProgressIndicator.adaptive());
    List<StoryContentDbModel>? allChanges = viewModel.draftStory?.allChanges?.reversed.toList();

    return ListView.separated(
      itemCount: allChanges?.length ?? 0,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final change = allChanges![index];
        bool isLatestChange = viewModel.draftStory?.latestChange?.id == change.id;

        return buildChangeTile(change, isLatestChange, context);
      },
    );
  }

  Widget buildChangeTile(StoryContentDbModel change, bool isLatestChange, BuildContext context) {
    return SpPopupMenuButton(
      smartDx: true,
      dyGetter: (dy) => dy + 88,
      items: (context) {
        return [
          SpPopMenuItem(
            title: "View",
            leadingIconData: Icons.book,
            onPressed: () {
              ShowChangeRoute(content: change).push(context);
            },
          ),
          if (!isLatestChange)
            SpPopMenuItem(
              leadingIconData: Icons.restore,
              title: "Restore this version",
              onPressed: () => viewModel.restore(context, change),
            ),
        ];
      },
      builder: (open) {
        return ListTile(
          onTap: open,
          isThreeLine: true,
          title: Text(change.title ?? 'N/A'),
          trailing: isLatestChange
              ? const Icon(Icons.lock)
              : IconButton(icon: const Icon(Icons.delete), onPressed: () => viewModel.draftRemove(change)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormatService.yMEd_jms(change.createdAt),
                style: TextTheme.of(context).labelMedium?.copyWith(color: ColorScheme.of(context).primary),
              ),
              const SizedBox(height: 4.0),
              SpMarkdownBody(body: change.displayShortBody!)
            ],
          ),
        );
      },
    );
  }

  Widget buildBottomNavigationBar(BuildContext context) {
    return Visibility(
      visible: viewModel.toBeRemovedCount > 0,
      child: SpFadeIn.fromBottom(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Divider(height: 1),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                spacing: 8.0,
                children: [
                  FilledButton.tonal(
                    child: const Text("Cancel"),
                    onPressed: () => viewModel.cancel(),
                  ),
                  FilledButton(
                    child: Text("Remove (${viewModel.toBeRemovedCount})"),
                    onPressed: () => viewModel.remove(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}