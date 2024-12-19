part of 'page_editor_view.dart';

class _PageEditorAdaptive extends StatelessWidget {
  const _PageEditorAdaptive(this.viewModel);

  final PageEditorViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(
        title: const Text('Edit'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => viewModel.save(context),
          ),
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
