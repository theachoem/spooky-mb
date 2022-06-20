part of clouds_storage_view;

class _CloudStoragesMobile extends StatelessWidget {
  final CloudStoragesViewModel viewModel;
  const _CloudStoragesMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SpExpandedAppBar(
            expandedHeight: 200,
            actions: [],
          ),
          SliverPadding(
            padding: ConfigConstant.layoutPadding,
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                ...viewModel.destinations.map((e) {
                  return CloudDestinationTile(
                    destination: e,
                    hasStory: viewModel.hasStory,
                  );
                }).toList(),
                const StoryPadBackupTile(),
              ]),
            ),
          )
        ],
      ),
    );
  }
}
