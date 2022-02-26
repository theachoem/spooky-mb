part of detail_view;

class _DetailMobile extends StatelessWidget {
  final DetailViewModel viewModel;
  const _DetailMobile(this.viewModel);

  ValueNotifier<bool> get readOnlyNotifier => viewModel.readOnlyNotifier;
  TextEditingController get titleController => viewModel.titleController;
  ValueNotifier<bool> get hasChangeNotifer => viewModel.hasChangeNotifer;
  List<List<dynamic>> get pages => viewModel.currentContent.pages ?? [];

  @override
  Widget build(BuildContext context) {
    return DetailScaffold(
      titleBuilder: () => buildTitle(),
      editorBuilder: () => buildEditor(context),
      toolbarBuilder: () => DetailToolbars(viewModel: viewModel),
      readOnlyNotifier: readOnlyNotifier,
      hasChangeNotifer: hasChangeNotifer,
      onSave: (context) => viewModel.save(),
      viewModel: viewModel,
    );
  }

  Widget buildEditor(BuildContext context) {
    if (pages.isEmpty) return Center(child: Text("No documents found"));
    return FocusScope(
      onFocusChange: (bool focused) {
        viewModel.toolbarVisibleNotifier.value = focused || !viewModel.titleFocusNode.hasFocus;
      },
      child: SpPageView(
        itemCount: pages.length,
        controller: viewModel.pageController,
        physics: const ClampingScrollPhysics(),
        onPageChanged: (int index) {
          // if title has focus,
          // body shouldn't request focus
          if (!viewModel.titleFocusNode.hasFocus) {
            viewModel.focusNodeAt(index)?.requestFocus();
          }
        },
        itemBuilder: (context, index) {
          return DetailEditor(
            document: pages[index],
            readOnlyNotifier: readOnlyNotifier,
            onChange: (_) => viewModel.onChange(_),
            onControllerReady: (controller) => viewModel.setQuillController(index, controller),
            onFocusNodeReady: (focusNode) => viewModel.setFocusNode(index, focusNode),
          );
        },
      ),
    );
  }

  Widget buildTitle() {
    return ValueListenableBuilder<bool>(
      valueListenable: readOnlyNotifier,
      builder: (context, value, child) {
        return TextField(
          style: M3TextTheme.of(context).titleLarge,
          autofocus: false,
          focusNode: viewModel.titleFocusNode,
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
