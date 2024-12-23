part of '../home_view_model.dart';

class _AppBarInfo {
  final BuildContext context;
  final double extraExpandedHeight;
  late final TextScaler scaler;

  _AppBarInfo({
    required this.context,
    required this.extraExpandedHeight,
  }) {
    scaler = MediaQuery.textScalerOf(context);
  }

  final double contentsMarginTop = 12;
  final double helloTextBaseHeight = 28;
  final double questionTextBaseHeight = 24;

  final double indicatorPaddingTop = 12;
  final double indicatorHeight = 40;
  final double indicatorPaddingBottom = 12;

  double getTabBarPreferredHeight() => indicatorPaddingTop + indicatorHeight + indicatorPaddingBottom;
  double getExpandedHeight() =>
      contentsMarginTop + getContentsHeight() + getTabBarPreferredHeight() + extraExpandedHeight;

  Size getYearSize() {
    double aspectRatio = 24 / 10;
    double baseHeight = 52;
    double baseWidth = baseHeight * aspectRatio;

    // make sure not bigger than 2.5 of screen width.
    double actualWidth = min(MediaQuery.of(context).size.width / 2.5, scaler.scale(baseWidth));
    double actualHeight = actualWidth / aspectRatio;

    return Size(actualWidth, actualHeight);
  }

  double getHelloTextHeight() => scaler.scale(helloTextBaseHeight);
  double getQuestionTextHeight() => scaler.scale(questionTextBaseHeight);
  double getContentsHeight() => getHelloTextHeight() + getQuestionTextHeight();
}

class _HomeScrollInfo {
  final HomeViewModel Function() viewModel;

  _AppBarInfo appBar(BuildContext context) => _AppBarInfo(context: context, extraExpandedHeight: extraExpandedHeight);

  bool _scrolling = false;
  double extraExpandedHeight = 0;

  final ScrollController scrollController = ScrollController();
  late final ListObserverController observerScrollController = ListObserverController(controller: scrollController);

  _HomeScrollInfo({
    required this.viewModel,
  });

  void setExtraExpandedHeight(double extra) {
    if (extraExpandedHeight == extra) return;

    extraExpandedHeight = extra;
    viewModel().notifyListeners();
  }

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
}
