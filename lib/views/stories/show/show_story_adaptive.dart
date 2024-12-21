part of 'show_story_view.dart';

class _StoryDetailsAdaptive extends StatelessWidget {
  const _StoryDetailsAdaptive(this.viewModel);

  final ShowStoryViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(
        title: Text(viewModel.currentContent?.title ?? 'Click to add title...'),
        actions: [
          if (viewModel.currentContent?.pages?.length != null && viewModel.currentContent!.pages!.length > 1)
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
        itemCount: viewModel.currentContent?.pages?.length ?? 0,
        itemBuilder: (context, index) {
          return QuillEditor.basic(
            controller: viewModel.quillControllers[index],
            configurations: const QuillEditorConfigurations(
              padding: EdgeInsets.all(16.0),
              checkBoxReadOnly: true,
              autoFocus: false,
              expands: true,
            ),
          );
        },
      ),
    );
  }

  Widget buildPageIndicator() {
    return Container(
      height: 48.0,
      alignment: Alignment.center,
      child: ValueListenableBuilder<double>(
        valueListenable: viewModel.currentPageNotifier,
        builder: (context, currentPage, child) {
          return Text('${viewModel.currentPage + 1} / ${viewModel.currentContent?.pages?.length}');
        },
      ),
    );
  }
}
