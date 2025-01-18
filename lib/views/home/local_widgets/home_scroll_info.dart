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

  final double contentsMarginTop = 20;
  final double helloTextBaseHeight = 28;
  final double questionTextBaseHeight = 24;
  final double contentsMarginBottom = 8;

  final double indicatorPaddingTop = 12;
  final double indicatorHeight = 40;
  final double indicatorPaddingBottom = 12;

  double getTabBarPreferredHeight() => indicatorPaddingTop + indicatorHeight + indicatorPaddingBottom;
  double getExpandedHeight() =>
      contentsMarginTop + getContentsHeight() + contentsMarginBottom + getTabBarPreferredHeight() + extraExpandedHeight;

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

class HomeScrollController extends ScrollController {}

class _HomeScrollInfo {
  final HomeViewModel Function() viewModel;
  final ScrollController scrollController = ScrollController();

  bool _scrolling = false;
  double extraExpandedHeight = 0;
  List<GlobalKey> storyKeys = [];

  _AppBarInfo appBar(BuildContext context) => _AppBarInfo(context: context, extraExpandedHeight: extraExpandedHeight);

  _HomeScrollInfo({
    required this.viewModel,
  }) {
    scrollController.addListener(_listener);
  }

  void dispose() {
    scrollController.dispose();
  }

  void setupStoryKeys(List<StoryDbModel> stories) {
    storyKeys = List.generate(stories.length, (_) => GlobalKey());
  }

  void setExtraExpandedHeight(double extra) {
    if (extraExpandedHeight == extra) return;

    extraExpandedHeight = extra;
    viewModel().notifyListeners();
  }

  void _listener() {
    if (_scrolling) return;
    final stories = viewModel().stories?.items ?? [];

    int? visibleIndex;
    for (int i = 0; i < storyKeys.length; i++) {
      if (storyKeys[i].currentContext == null) continue;

      final context = storyKeys[i].currentContext;
      if (context != null) {
        double expandedHeight = appBar(context).getExpandedHeight();
        double scrollOffset = max(0.0, scrollController.offset - expandedHeight + MediaQuery.of(context).padding.top);

        final renderBox = context.findRenderObject() as RenderBox?;
        double? itemPosition = renderBox?.localToGlobal(Offset(0.0, scrollOffset)).dy;

        if (itemPosition != null && itemPosition > scrollOffset + 48) {
          visibleIndex = i;
          break;
        }
      }
    }

    if (visibleIndex != null) {
      int? month = stories.elementAt(visibleIndex).month;
      int monthIndex = viewModel().months.indexWhere((e) => month == e);
      DefaultTabController.of(storyKeys[visibleIndex].currentContext!).animateTo(monthIndex);
    }
  }

  Future<void> moveToMonthIndex({
    required List<int> months,
    required int targetMonthIndex,
    required BuildContext context,
  }) async {
    _scrolling = true;

    List<StoryDbModel> stories = viewModel().stories?.items ?? [];

    int targetStoryIndex = stories.indexWhere((e) => e.month == months[targetMonthIndex]);
    final targetStoryKey = storyKeys.elementAt(targetStoryIndex);

    (bool, int) result = _getScrollInfo(storyKeys, months, stories, targetMonthIndex);

    bool isMovingRight = result.$1;
    int nearestToTargetStoryIndex = result.$2;

    if (targetStoryKey.currentContext == null) {
      if (isMovingRight) {
        for (int i = nearestToTargetStoryIndex; i <= targetStoryIndex; i++) {
          final visibleKey = storyKeys[i];
          final nextVisibleKey = (i + 1 < storyKeys.length) ? storyKeys[i + 1] : null;

          if (visibleKey.currentContext == null) continue;
          if (i != targetStoryIndex && nextVisibleKey?.currentContext != null) continue;

          await Scrollable.ensureVisible(
            visibleKey.currentContext!,
            duration: i == targetStoryIndex ? Durations.medium3 : Durations.short1,
            curve: i == targetStoryIndex ? Curves.ease : Curves.linear,
          );
        }
      } else {
        for (int i = nearestToTargetStoryIndex; i >= targetStoryIndex; i--) {
          final visibleKey = storyKeys[i];
          final nextVisibleKey = i > 0 ? storyKeys[i - 1] : null;

          if (visibleKey.currentContext == null) continue;
          if (i != targetStoryIndex && nextVisibleKey?.currentContext != null) continue;

          await Scrollable.ensureVisible(
            visibleKey.currentContext!,
            duration: i == targetStoryIndex ? Durations.medium3 : Durations.short1,
            curve: i == targetStoryIndex ? Curves.ease : Curves.linear,
          );
        }
      }
    } else {
      await Scrollable.ensureVisible(
        targetStoryKey.currentContext!,
        duration: Durations.medium3,
        curve: Curves.ease,
      );
    }

    if (targetStoryIndex == 0) {
      await scrollController.animateTo(0.0, duration: Durations.medium3, curve: Curves.ease);
    }

    _scrolling = false;
  }

  (bool, int) _getScrollInfo(
    List<GlobalKey<State<StatefulWidget>>> storyKeys,
    List<int> months,
    List<StoryDbModel> stories,
    int targetMonthIndex,
  ) {
    List<int> visibleStoryIndexes = [];

    for (int i = 0; i < storyKeys.length; i++) {
      if (storyKeys[i].currentContext != null) visibleStoryIndexes.add(i);
    }

    Set<int> visibleMonthIndexs = visibleStoryIndexes.map((index) {
      return months.indexWhere((month) => month == stories[index].month);
    }).toSet();

    bool isMovingRight = visibleMonthIndexs.every((monthIndex) => targetMonthIndex > monthIndex);
    return (isMovingRight, isMovingRight ? visibleStoryIndexes.last : visibleStoryIndexes.first);
  }
}
