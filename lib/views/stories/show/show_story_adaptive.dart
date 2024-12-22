part of 'show_story_view.dart';

class _StoryDetailsAdaptive extends StatelessWidget {
  const _StoryDetailsAdaptive(this.viewModel);

  final ShowStoryViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        clipBehavior: Clip.none,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        titleSpacing: 0.0,
        title: SpPopupMenuButton(
          dxGetter: (dx) => dx + 96,
          dyGetter: (dy) => dy + 48,
          builder: (void Function() callback) {
            return InkWell(
              onTap: callback,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: AppBarTheme.of(context).titleSpacing!),
                width: double.infinity,
                height: kToolbarHeight,
                alignment: Alignment.centerLeft,
                child: Text(viewModel.draftContent?.title ?? 'Title...'),
              ),
            );
          },
          items: (BuildContext context) {
            return [
              SpPopMenuItem(
                title: 'Rename',
                leadingIconData: Icons.edit,
                onPressed: () => viewModel.renameTitle(context),
              ),
              SpPopMenuItem(
                title: 'Changes History',
                leadingIconData: Icons.history,
                onPressed: () => viewModel.goToChangesPage(context),
              ),
            ];
          },
        ),
        actions: [
          if (viewModel.draftContent?.pages?.length != null && viewModel.draftContent!.pages!.length > 1)
            buildPageIndicator(),
          const SizedBox(width: 12.0),
          SpFeelingButton(
            feeling: viewModel.story?.feeling,
            onPicked: (feeling) => viewModel.setFeeling(feeling),
          ),
          IconButton(
            onPressed: () => viewModel.goToEditPage(context),
            icon: const Icon(Icons.edit_outlined),
          ),
          const SizedBox(width: 4.0),
        ],
        bottom: const PreferredSize(preferredSize: Size.fromHeight(1), child: Divider(height: 1)),
      ),
      body: PageView.builder(
        controller: viewModel.pageController,
        itemCount: viewModel.quillControllers.length,
        itemBuilder: (context, index) {
          return QuillEditor.basic(
            controller: viewModel.quillControllers[index],
            configurations: const QuillEditorConfigurations(
              padding: EdgeInsets.all(16.0),
              checkBoxReadOnly: true,
              showCursor: false,
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
          return Text('${viewModel.currentPage + 1} / ${viewModel.draftContent?.pages?.length}');
        },
      ),
    );
  }
}
