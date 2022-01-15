part of content_reader_view;

class _ContentReaderMobile extends StatelessWidget {
  final ContentReaderViewModel viewModel;
  const _ContentReaderMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(
        leading: SpPopButton(),
        title: Text(
          viewModel.content.title ?? "No title",
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: Stack(
        children: [
          PageView.builder(
            controller: viewModel.pageController,
            itemCount: viewModel.content.pages?.length ?? 0,
            itemBuilder: (context, index) {
              List<dynamic>? page = viewModel.content.pages?[index];
              return ContentPageViewer(document: page);
            },
          ),
          buildIndicator(),
        ],
      ),
    );
  }

  Widget buildIndicator() {
    return ContentIndicator(
      controller: viewModel.pageController,
      pagesCount: viewModel.content.pages?.length ?? 0,
    );
  }
}
