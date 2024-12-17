part of 'story_details_view.dart';

class _StoryDetailsAdaptive extends StatelessWidget {
  const _StoryDetailsAdaptive(this.viewModel);

  final StoryDetailsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(viewModel.story?.createdAt.toString() ?? 'NA'),
        actions: [
          ValueListenableBuilder<double>(
            valueListenable: viewModel.currentPageNotifier,
            builder: (context, currentPage, child) {
              return Text('${currentPage + 1} / ${viewModel.currentStoryContent?.pages?.length}');
            },
          ),
          IconButton(
            onPressed: () => viewModel.createNewPage(context),
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () => viewModel.goToEditPage(context),
            icon: const Icon(Icons.edit),
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
          );
        },
      ),
    );
  }
}
