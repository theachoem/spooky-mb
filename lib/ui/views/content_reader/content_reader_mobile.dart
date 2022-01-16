part of content_reader_view;

class _ContentReaderMobile extends StatelessWidget {
  final ContentReaderViewModel viewModel;
  const _ContentReaderMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        backgroundColor: M3Color.of(context).background,
        floatingActionButton: buildToggleFullscreenFAB(),
        body: Stack(
          children: [
            GestureDetector(
              onTapDown: (_) {
                viewModel.fullscreenNotifier.value = true;
              },
              onDoubleTap: () {
                viewModel.toggleFullscreen();
              },
              child: TweenAnimationBuilder<int>(
                duration: ConfigConstant.duration * 2,
                tween: IntTween(begin: 0, end: 1),
                child: buildBody(context),
                builder: (context, value, child) {
                  return AnimatedOpacity(
                    opacity: value.toDouble(),
                    duration: ConfigConstant.duration * 2,
                    child: child,
                  );
                },
              ),
            ),
            buildIndicator(context),
            buildAppBar(),
          ],
        ),
      ),
    );
  }

  Widget buildAppBar() {
    return ValueListenableBuilder<bool>(
      valueListenable: viewModel.fullscreenNotifier,
      builder: (context, fullscreen, child) {
        return Wrap(
          children: [
            AnimatedOpacity(
              duration: ConfigConstant.fadeDuration,
              opacity: fullscreen ? 0 : 1,
              curve: Curves.ease,
              child: AnimatedContainer(
                duration: ConfigConstant.fadeDuration,
                curve: Curves.ease,
                transform: Matrix4.identity()..translate(0.0, fullscreen ? -kToolbarHeight : 0),
                child: AppBar(
                  leading: SpPopButton(color: M3Color.of(context).onPrimaryContainer),
                  backgroundColor: M3Color.of(context).primaryContainer,
                  foregroundColor: M3Color.of(context).onPrimaryContainer,
                  systemOverlayStyle: M3Color.of(context).brightness == Brightness.dark
                      ? SystemUiOverlayStyle.light
                      : SystemUiOverlayStyle.dark,
                  title: Text(
                    viewModel.content.title ?? "No title",
                    style: Theme.of(context)
                        .appBarTheme
                        .titleTextStyle
                        ?.copyWith(color: M3Color.of(context).onPrimaryContainer),
                  ),
                  actions: [
                    SpThemeSwitcher(
                      backgroundColor: Colors.transparent,
                      color: M3Color.of(context).onPrimaryContainer,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildToggleFullscreenFAB() {
    return FloatingActionButton(
      onPressed: () {
        viewModel.toggleFullscreen();
      },
      shape: RoundedRectangleBorder(borderRadius: ConfigConstant.circlarRadius2),
      child: ValueListenableBuilder<bool>(
        valueListenable: viewModel.fullscreenNotifier,
        builder: (context, fullscreen, child) {
          return SpAnimatedIcons(
            showFirst: fullscreen,
            firstChild: Icon(
              Icons.fullscreen,
              key: ValueKey(Icons.fullscreen),
            ),
            secondChild: Icon(
              Icons.fullscreen_exit,
              key: ValueKey(Icons.fullscreen_exit),
            ),
          );
        },
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return PageTurn(
      key: viewModel.pageTurnState,
      children: List.generate(viewModel.content.pages?.length ?? 0, (index) {
        List<dynamic> page = viewModel.content.pages![index];
        return Container(
          color: M3Color.of(context).background,
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + kToolbarHeight),
          child: ContentPageViewer(document: page),
        );
      }),
    );
  }

  Widget buildAppBarTitle(BuildContext context) {
    return Text(
      viewModel.content.title ?? "No title",
      style: Theme.of(context).appBarTheme.titleTextStyle,
    );
  }

  Widget buildIndicator(BuildContext context) {
    int length = viewModel.content.pages?.length ?? 0;
    return Positioned(
      bottom: MediaQuery.of(context).padding.bottom + kToolbarHeight / 2 + 12,
      right: 0,
      left: 0,
      child: Container(
        width: double.infinity,
        alignment: Alignment.bottomCenter,
        child: ValueListenableBuilder<int>(
          valueListenable: viewModel.pageNotifier,
          builder: (context, value, child) {
            return AnimatedSmoothIndicator(
              activeIndex: value,
              effect: WormEffect(dotHeight: 4),
              count: length,
            );
          },
        ),
      ),
    );
  }
}
