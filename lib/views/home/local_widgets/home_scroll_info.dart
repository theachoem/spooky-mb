part of '../home_view_model.dart';

class _HomeScrollInfo {
  final HomeViewModel Function() viewModel;

  bool _scrolling = false;

  final ScrollController scrollController = ScrollController();
  late final ListObserverController observerScrollController = ListObserverController(controller: scrollController);

  _HomeScrollInfo({
    required this.viewModel,
  });

  void dispose() {
    scrollController.dispose();
  }

  void onObserve(ListViewObserveModel observeResult, BuildContext context) {
    if (_scrolling) return;

    int index = observeResult.firstChild?.index ?? 0;

    StoryDbModel? story = viewModel().stories?.items[index];
    int tabIndex = viewModel().months.indexWhere((e) => e == story?.month);

    DefaultTabController.of(context).animateTo(tabIndex);
  }

  Future<void> moveToMonthIndex(int monthIndex) async {
    _scrolling = true;

    if (monthIndex == 0) {
      await scrollController.animateTo(0, duration: Durations.medium3, curve: Curves.ease);
    } else {
      final month = viewModel().months[monthIndex];
      int? storyIndex = viewModel().stories?.items.indexWhere((e) => e.month == month);
      if (storyIndex == null) return;

      await observerScrollController.animateTo(
        index: storyIndex,
        duration: Durations.medium3,
        curve: Curves.ease,
      );
    }

    _scrolling = false;
  }

  double getExpandedHeight(BuildContext context) => kToolbarHeight + 68 + MediaQuery.of(context).padding.top;
}
