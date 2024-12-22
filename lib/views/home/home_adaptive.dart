part of 'home_view.dart';

const double _indicatorHeight = 40;

class _HomeAdaptive extends StatelessWidget {
  const _HomeAdaptive(this.viewModel);

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: viewModel.months.length,
      child: _HomeScaffold(
        viewModel: viewModel,
        endDrawer: _HomeEndDrawer(viewModel),
        appBar: HomeAppBar(viewModel: viewModel),
        body: buildBody(context),
        floatingActionButton: FloatingActionButton(
          onPressed: () => viewModel.goToNewPage(context),
          child: const Icon(Icons.edit),
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: 16.0)
          .copyWith(left: MediaQuery.of(context).padding.left, right: MediaQuery.of(context).padding.right),
      sliver: SliverList.builder(
        itemCount: viewModel.stories?.items.length ?? 0,
        itemBuilder: (context, index) {
          return StoryTileListItem(
            showYear: false,
            index: index,
            stories: viewModel.stories!,
            onTap: () => viewModel.goToViewPage(context, viewModel.stories!.items[index]),
            onToggleStarred: () => viewModel.toggleStarred(viewModel.stories!.items[index]),
          );
        },
      ),
    );
  }
}
