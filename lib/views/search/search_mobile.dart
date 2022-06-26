part of search_view;

class _SearchMobile extends StatelessWidget {
  final SearchViewModel viewModel;
  const _SearchMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(
        leading: const SpPopButton(),
        title: const SpAppBarTitle(fallbackRouter: SpRouter.search),
      ),
      body: StoryQueryList(
        queryOptions: viewModel.initialQuery ?? StoryQueryOptionsModel(type: PathType.docs),
        overridedLayout: ListLayoutType.single,
      ),
    );
  }
}
