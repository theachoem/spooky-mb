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
      ),
    );
  }
}
