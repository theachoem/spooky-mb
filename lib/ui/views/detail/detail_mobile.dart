part of detail_view;

class _DetailMobile extends StatelessWidget {
  final DetailViewModel viewModel;
  const _DetailMobile(this.viewModel);

  ValueNotifier<bool> get readOnlyNotifier => viewModel.readOnlyNotifier;
  TextEditingController get titleController => viewModel.titleController;
  ValueNotifier<bool> get hasChangeNotifer => viewModel.hasChangeNotifer;

  @override
  Widget build(BuildContext context) {
    return DetailScaffold(
      titleBuilder: (state) => buildTitle(state),
      editorBuilder: (state) => buildEditor(state),
      readOnlyNotifier: readOnlyNotifier,
      hasChangeNotifer: hasChangeNotifer,
      onSave: (context) => viewModel.save(context),
      viewModel: viewModel,
    );
  }

  Widget buildEditor(GlobalKey<ScaffoldState> state) {
    return PageView.builder(
      itemCount: 2,
      controller: viewModel.pageController,
      itemBuilder: (context, index) {
        return DetailEditor(
          document: viewModel.currentStory.document,
          readOnlyNotifier: readOnlyNotifier,
          onChange: (_) => viewModel.onChange(_),
          onControllerReady: (controller) {
            viewModel.quillControllers[index] = controller;
            print(controller);
            print(viewModel.quillControllers);
          },
          onFocusNodeReady: (focusNode) {
            viewModel.focusNodes[index] = focusNode;
          },
        );
      },
    );
  }

  Widget buildTitle(GlobalKey<ScaffoldState> state) {
    return ValueListenableBuilder<bool>(
      valueListenable: readOnlyNotifier,
      builder: (context, value, child) {
        return TextField(
          style: M3TextTheme.of(context).titleLarge,
          autofocus: false,
          readOnly: readOnlyNotifier.value,
          controller: titleController,
          keyboardAppearance: M3Color.keyboardAppearance(context),
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 4.0),
            hintText: 'Title...',
            border: UnderlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.zero,
            ),
          ),
        );
      },
    );
  }
}
