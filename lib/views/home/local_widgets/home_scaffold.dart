part of '../home_view.dart';

class _HomeScaffold extends StatelessWidget {
  const _HomeScaffold({
    required this.endDrawer,
    required this.viewModel,
    required this.appBar,
    required this.body,
    required this.floatingActionButton,
  });

  final HomeViewModel viewModel;
  final Widget? endDrawer;
  final Widget appBar;
  final Widget body;
  final Widget floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: endDrawer,
      floatingActionButton: floatingActionButton,
      body: Stack(
        children: [
          const StoryListTimelineVerticleDivider(),
          ListViewObserver(
            controller: viewModel.scrollInfo.observerScrollController,
            onObserve: (result) => viewModel.scrollInfo.onObserve(result, context),
            child: RefreshIndicator.adaptive(
              edgeOffset: viewModel.scrollInfo.appBar(context).getExpandedHeight(),
              onRefresh: () => viewModel.load(),
              child: CustomScrollView(
                controller: viewModel.scrollInfo.scrollController,
                slivers: [
                  appBar,
                  body,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
