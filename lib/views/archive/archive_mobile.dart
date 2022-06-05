part of archive_view;

class _ArchiveMobile extends StatelessWidget {
  final ArchiveViewModel viewModel;
  const _ArchiveMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(
        title: const SpAppBarTitle(fallbackRouter: SpRouter.archive),
        leading: ModalRoute.of(context)?.canPop == true ? const SpPopButton() : null,
      ),
      body: StoryQueryList(
        queryOptions: StoryQueryOptionsModel(type: PathType.archives),
      ),
    );
  }
}
