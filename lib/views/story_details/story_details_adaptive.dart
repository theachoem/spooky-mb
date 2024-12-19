part of 'story_details_view.dart';

class _StoryDetailsAdaptive extends StatelessWidget {
  const _StoryDetailsAdaptive(this.viewModel);

  final StoryDetailsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(
        title: Text(viewModel.currentStoryContent?.title ?? 'Click to add title...'),
        actions: [
          if (viewModel.currentStoryContent?.pages?.length != null && viewModel.currentStoryContent!.pages!.length > 1)
            buildPageIndicator(),
          const SizedBox(width: 12.0),
          IconButton(
            onPressed: () => viewModel.goToEditPage(context),
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: PageView.builder(
        controller: viewModel.pageController,
        itemCount: viewModel.currentStoryContent?.pages?.length ?? 0,
        itemBuilder: (context, index) {
          final pageDocuments = viewModel.currentStoryContent!.pages![index];
          return PageReader(
            pageDocuments: pageDocuments,
            onSelectionChanged: (TextSelection selection) => viewModel.currentTextSelection = selection,
          );
        },
      ),
    );
  }

  Container buildPageIndicator() {
    return Container(
      height: 48.0,
      alignment: Alignment.center,
      child: ValueListenableBuilder<double>(
        valueListenable: viewModel.currentPageNotifier,
        builder: (context, currentPage, child) {
          return Text('${viewModel.currentPage + 1} / ${viewModel.currentStoryContent?.pages?.length}');
        },
      ),
    );
  }
}
