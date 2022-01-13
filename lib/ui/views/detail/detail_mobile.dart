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
      titleBuilder: (state) => buildTitle(state),
      editorBuilder: (state) => buildEditor(state),
      toolbarBuilder: (state) => buildToolbar(state),
      readOnlyNotifier: readOnlyNotifier,
    );
  }

  Widget buildToolbar(GlobalKey<ScaffoldState> state) {
    // TODO: Implement toolbars
    return Text("data");
  }

  Widget buildEditor(GlobalKey<ScaffoldState> state) {
    // TODO: Implement Editor
    return Text("data");
  }

  Widget buildTitle(GlobalKey<ScaffoldState> state) {
    return ValueListenableBuilder<bool>(
      valueListenable: readOnlyNotifier,
      builder: (context, value, child) {
        return TextField(
          style: M3TextTheme.of(context)?.titleLarge,
          autofocus: false,
          readOnly: readOnlyNotifier.value,
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
