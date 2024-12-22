part of '../home_view.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    super.key,
    required this.viewModel,
  });

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      actions: const [SizedBox()],
      automaticallyImplyLeading: false,
      pinned: true,
      floating: true,
      elevation: 0.0,
      scrolledUnderElevation: 0.0,
      forceElevated: false,
      surfaceTintColor: Theme.of(context).colorScheme.surface,
      backgroundColor: Theme.of(context).colorScheme.surface,
      expandedHeight: viewModel.scrollInfo.getExpandedHeight(context),
      flexibleSpace: buildFlexibleSpaceBar(context),
      bottom: buildTabBar(context),
    );
  }

  PreferredSize buildTabBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(_indicatorHeight + 8.0 * 2),
      child: TabBar(
        enableFeedback: true,
        tabAlignment: TabAlignment.start,
        isScrollable: true,
        indicatorAnimation: TabIndicatorAnimation.linear,
        labelColor: Theme.of(context).colorScheme.onPrimary,
        unselectedLabelColor: Theme.of(context).colorScheme.primary,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        indicator: RoundedIndicator.simple(
          height: _indicatorHeight,
          color: Theme.of(context).colorScheme.primary,
        ),
        onTap: (index) => viewModel.scrollInfo.moveToMonthIndex(index),
        splashBorderRadius: BorderRadius.circular(_indicatorHeight / 2),
        tabs: viewModel.months.map((month) {
          return Container(
            height: _indicatorHeight - 2,
            alignment: Alignment.center,
            child: Text(DateFormatService.MMM(DateTime(2000, month))),
          );
        }).toList(),
      ),
    );
  }

  Widget buildFlexibleSpaceBar(BuildContext context) {
    return FlexibleSpaceBar(
      background: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0).add(EdgeInsets.only(
          left: MediaQuery.of(context).padding.left,
          right: MediaQuery.of(context).padding.left,
          top: MediaQuery.of(context).padding.top + 16.0,
          bottom: _indicatorHeight + 8 * 2,
        )),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 16.0,
          children: [
            SpTapEffect(
              onTap: () => viewModel.changeName(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _HomeAppBarNickname(nickname: viewModel.user?.nickname),
                  Text(
                    "What did you have in mind?",
                    overflow: TextOverflow.ellipsis,
                    style: TextTheme.of(context).bodyLarge,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            FittedBox(
              child: SpTapEffect(
                effects: const [SpTapEffectType.touchableOpacity],
                onTap: () {
                  Scaffold.maybeOf(context)?.openEndDrawer();
                },
                child: Text(
                  viewModel.year.toString(),
                  overflow: TextOverflow.ellipsis,
                  style: TextTheme.of(context).displayLarge?.copyWith(color: Theme.of(context).disabledColor),
                  textAlign: TextAlign.end,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
