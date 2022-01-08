part of archive_view;

class _ArchiveMobile extends StatelessWidget {
  final ArchiveViewModel viewModel;
  const _ArchiveMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(
        title: Text(
          'Archive',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: StoryList(
        onRefresh: () => viewModel.load(),
        stories: viewModel.stories,
        onDelete: (StoryModel story) {
          return viewModel.delete(story);
        },
        onUnarchive: (StoryModel story) async {
          var result = await viewModel.unachieveDocument(story);
          print("RESULT: $result");
          print("MSG: ${viewModel.archiveManager.error}");
          return result;
        },
      ),
    );
  }
}
