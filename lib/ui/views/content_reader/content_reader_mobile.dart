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
        appBar: buildAppBar(context),
        body: buildBody(context),
      ),
    );
  }

  PreferredSizeWidget buildAppBar(BuildContext context) {
    return MorphingAppBar(
      leading: SpPopButton(),
      actions: [
        PageIndicatorButton(
          controller: viewModel.pageController,
          pagesCount: viewModel.content.pages?.length ?? 0,
          quillControllerGetter: (index) => viewModel.quillControllers[index],
        ),
        ConfigConstant.sizedBoxW2,
      ],
      systemOverlayStyle:
          M3Color.of(context).brightness == Brightness.dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      title: Text(
        viewModel.content.title ?? "No title",
        style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(color: M3Color.of(context).onPrimaryContainer),
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

  Widget buildAppBarTitle(BuildContext context) {
    return Text(
      viewModel.content.title ?? "No title",
      style: Theme.of(context).appBarTheme.titleTextStyle,
    );
  }
}
