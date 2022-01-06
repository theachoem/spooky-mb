part of detail_view;

class _DetailMobile extends StatelessWidget {
  final DetailViewModel viewModel;
  const _DetailMobile(this.viewModel);

  FocusNode get focusNode => viewModel.focusNode;
  editor.QuillController get controller => viewModel.controller;
  ScrollController get scrollController => viewModel.scrollController;
  ValueNotifier<bool> get readOnlyNotifier => viewModel.readOnlyNotifier;

  @override
  Widget build(BuildContext context) {
    return DetailScaffold(
      appBar: buildAppBar(context),
      editor: buildEditor(context),
      toolbar: buildToolbar(),
      readOnlyNotifier: readOnlyNotifier,
    );
  }

  editor.QuillToolbar buildToolbar() {
    return editor.QuillToolbar.basic(
      controller: controller,
      multiRowsDisplay: false,
      toolbarIconSize: ConfigConstant.iconSize2,
    );
  }

  Widget buildEditor(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: readOnlyNotifier,
      builder: (context, value, child) {
        return editor.QuillEditor(
          controller: controller,
          scrollController: scrollController,
          scrollable: true,
          focusNode: focusNode,
          autoFocus: false,
          readOnly: readOnlyNotifier.value,
          expands: false,
          padding: EdgeInsets.all(ConfigConstant.margin2),
          keyboardAppearance: M3Color.keyboardAppearance(context),
        );
      },
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      leading: SpPopButton(),
      title: ValueListenableBuilder<bool>(
        valueListenable: readOnlyNotifier,
        builder: (context, value, child) {
          return TextField(
            style: M3TextTheme.of(context)?.titleLarge,
            autofocus: false,
            readOnly: readOnlyNotifier.value,
            keyboardAppearance: M3Color.keyboardAppearance(context),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
              hintText: 'Title...',
              border: UnderlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.zero,
              ),
            ),
          );
        },
      ),
      actions: [
        SpPopupMenuButton(
          fromAppBar: true,
          items: [
            SpPopMenuItem(
              title: "Info",
              onPressed: () {},
            ),
            SpPopMenuItem(
              title: "Delete",
              onPressed: () {},
            ),
          ],
          builder: (callback) {
            return SpIconButton(
              icon: Icon(Icons.more_vert),
              onPressed: callback,
            );
          },
        ),
      ],
    );
  }
}
