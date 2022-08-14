part of content_reader_view;

class _ContentReaderMobile extends StatelessWidget {
  final ContentReaderViewModel viewModel;
  const _ContentReaderMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: M3Color.of(context).background,
      appBar: buildAppBar(context),
      body: buildBody(context),
    );
  }

  PreferredSizeWidget buildAppBar(BuildContext context) {
    return MorphingAppBar(
      heroTag: DetailView.appBarHeroKey,
      leading: const SpPopButton(),
      actions: [
        PageIndicatorButton(
          controller: viewModel.pageController,
          pagesCount: viewModel.content.pages?.length ?? 0,
          quillControllerGetter: (index) => viewModel.quillControllers[index],
        ),
        SizedBox(width: (viewModel.content.pages ?? []).length > 1 ? 16.0 : 8.0)
      ],
      title: Text(
        viewModel.content.title ?? tr("msg.no_title"),
        style: Theme.of(context).appBarTheme.titleTextStyle,
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return SpPageView(
      controller: viewModel.pageController,
      itemCount: viewModel.content.pages?.length ?? 0,
      itemBuilder: (context, index) {
        List<dynamic> page = viewModel.content.pages![index];
        return ContentPageViewer(
          document: page,
          onControllerReady: (controller) => viewModel.quillControllers[index] = controller,
        );
      },
    );
  }
}
