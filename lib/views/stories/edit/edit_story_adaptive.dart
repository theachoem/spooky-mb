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
          buildSavedMessage(),
          const SizedBox(width: 8.0),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => context.pop(),
          ),
          const SizedBox(width: 4.0),
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

  Widget buildSavedMessage() {
    return ValueListenableBuilder(
      valueListenable: viewModel.lastSavedAtNotifier,
      builder: (context, lastSavedAt, child) {
        if (lastSavedAt == null) return const SizedBox.shrink();

        return Tooltip(
          message: "This story is auto saved at ${DateFormatService.jms(lastSavedAt)}",
          child: RichText(
            text: TextSpan(
              style: TextTheme.of(context).bodyMedium,
              text: DateFormatService.jms(lastSavedAt),
              children: const [
                WidgetSpan(
                  child: Padding(
                    padding: EdgeInsets.only(left: 4.0),
                    child: Icon(Icons.check_circle_outline, size: 16.0),
                  ),
                  alignment: PlaceholderAlignment.middle,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
