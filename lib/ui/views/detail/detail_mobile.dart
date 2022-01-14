part of detail_view;

class _DetailMobile extends StatelessWidget {
  final DetailViewModel viewModel;
  const _DetailMobile(this.viewModel);

  ValueNotifier<bool> get readOnlyNotifier => viewModel.readOnlyNotifier;
  TextEditingController get titleController => viewModel.titleController;
  ValueNotifier<bool> get hasChangeNotifer => viewModel.hasChangeNotifer;
  List<List<dynamic>> get documents => viewModel.documents;

  @override
  Widget build(BuildContext context) {
    return DetailScaffold(
      titleBuilder: () => buildTitle(),
      editorBuilder: () => buildEditor(context),
      readOnlyNotifier: readOnlyNotifier,
      hasChangeNotifer: hasChangeNotifer,
      onSave: (context) => viewModel.save(context),
      viewModel: viewModel,
    );
  }

  Widget buildEditor(BuildContext context) {
    if (documents.isEmpty) return Center(child: Text("No documents found"));
    return PageView.builder(
      itemCount: documents.length,
      controller: viewModel.pageController,
      physics: const ClampingScrollPhysics(),
      itemBuilder: (context, index) {
        return DetailEditor(
          document: documents[index],
          readOnlyNotifier: readOnlyNotifier,
          onChange: (_) => viewModel.onChange(_),
          onControllerReady: (controller) {
            viewModel.quillControllers[index] = controller;
          },
          onFocusNodeReady: (focusNode) {
            viewModel.focusNodes[index] = focusNode;
          },
        );
      },
    );
  }

  Widget buildTitle() {
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
