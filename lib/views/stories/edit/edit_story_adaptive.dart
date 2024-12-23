part of 'edit_story_view.dart';

class _EditStoryAdaptive extends StatelessWidget {
  const _EditStoryAdaptive(this.viewModel);

  final EditStoryViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: viewModel.story != null
          ? TagsEndDrawer(
              onUpdated: (tags) => viewModel.setTags(tags),
              initialTags: viewModel.story?.tags ?? [],
            )
          : null,
      appBar: AppBar(
        clipBehavior: Clip.none,
        titleSpacing: 0.0,
        title: viewModel.story == null
            ? const SizedBox.shrink()
            : StoryTitle(
                content: viewModel.draftContent,
                changeTitle: () => viewModel.changeTitle(context),
                backgroundColor: Theme.of(context).appBarTheme.backgroundColor!,
              ),
        actions: [
          const SizedBox(width: 4.0),
          buildSavedMessage(),
          const SizedBox(width: 12.0),
          Builder(builder: (context) {
            return IconButton(
              icon: const Icon(Icons.sell_outlined),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            );
          }),
          SpFeelingButton(
            feeling: viewModel.story?.feeling,
            onPicked: (feeling) => viewModel.setFeeling(feeling),
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 4.0),
        ],
        bottom: const PreferredSize(preferredSize: Size.fromHeight(1), child: Divider(height: 1)),
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
            textScaler: MediaQuery.textScalerOf(context),
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
