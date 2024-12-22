part of 'edit_story_view.dart';

class _EditStoryAdaptive extends StatelessWidget {
  const _EditStoryAdaptive(this.viewModel);

  final EditStoryViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: viewModel.story == null
            ? const SizedBox.shrink()
            : SpTapEffect(
                onTap: () => viewModel.changeTitle(context),
                child: Text(viewModel.draftContent?.title ?? 'Title...'),
              ),
        actions: [
          ValueListenableBuilder(
            valueListenable: viewModel.lastSavedAtNotifier,
            builder: (context, lastSavedAt, child) {
              if (lastSavedAt == null) return const SizedBox.shrink();
              return Container(
                margin: const EdgeInsets.only(right: 16.0),
                child: Text(
                  lastSavedAt.toString(),
                  style: TextTheme.of(context).bodyMedium,
                ),
              );
            },
          )
        ],
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    if (viewModel.quillControllers.isEmpty) {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    } else {
      return PageView.builder(
        controller: viewModel.pageController,
        itemCount: viewModel.quillControllers.length,
        itemBuilder: (context, index) {
          return _Editor(
            controller: viewModel.quillControllers[index]!,
            showToolbarOnTop: viewModel.showToolbarOnTop,
            showToolbarOnBottom: viewModel.showToolbarOnBottom,
            toggleToolbarPosition: viewModel.toggleToolbarPosition,
          );
        },
      );
    }
  }
}
