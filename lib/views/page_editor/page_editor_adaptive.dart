part of 'page_editor_view.dart';

class _PageEditorAdaptive extends StatelessWidget {
  const _PageEditorAdaptive(this.viewModel);

  final PageEditorViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => viewModel.save(context),
          ),
        ],
        bottom: viewModel.showToolbarOnTop
            ? PreferredSize(
                preferredSize: const Size.fromHeight(50.0),
                child: buildToolBar(),
              )
            : null,
      ),
      body: buildBody(context),
      bottomNavigationBar: viewModel.showToolbarOnBottom
          ? AnimatedContainer(
              duration: Durations.medium1,
              curve: Curves.ease,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + MediaQuery.of(context).viewInsets.bottom,
              ),
              child: buildToolBar(),
            )
          : null,
    );
  }

  Widget buildBody(BuildContext context) {
    if (viewModel.controller == null) {
      return const Center(child: CircularProgressIndicator.adaptive());
    } else {
      return buildPagesEditor();
    }
  }

  Widget buildPagesEditor() {
    return QuillEditor.basic(
      controller: viewModel.controller,
      configurations: const QuillEditorConfigurations(
        padding: EdgeInsets.all(16.0),
        autoFocus: true,
        enableScribble: true,
      ),
    );
  }

  Widget buildToolBar() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(height: 1),
        IntrinsicHeight(
          child: Row(
            children: [
              IconButton(
                icon: viewModel.showToolbarOnTop
                    ? const Icon(Icons.keyboard_double_arrow_down)
                    : const Icon(Icons.keyboard_double_arrow_up),
                onPressed: () => viewModel.toggleToolbarPosition(),
              ),
              const VerticalDivider(width: 1),
              Expanded(
                child: QuillSimpleToolbar(
                  controller: viewModel.controller,
                  configurations: const QuillSimpleToolbarConfigurations(
                    multiRowsDisplay: false,
                    showDividers: true,
                    showFontFamily: false,
                    showFontSize: false,
                    showBoldButton: true,
                    showItalicButton: true,
                    showSmallButton: true,
                    showUnderLineButton: true,
                    showLineHeightButton: false,
                    showStrikeThrough: true,
                    showInlineCode: true,
                    showColorButton: true,
                    showBackgroundColorButton: true,
                    showClearFormat: false,
                    showAlignmentButtons: true,
                    showLeftAlignment: true,
                    showCenterAlignment: true,
                    showRightAlignment: true,
                    showJustifyAlignment: true,
                    showHeaderStyle: false,
                    showListNumbers: true,
                    showListBullets: true,
                    showListCheck: true,
                    showCodeBlock: false,
                    showQuote: true,
                    showIndent: true,
                    showLink: true,
                    showUndo: true,
                    showRedo: true,
                    showDirection: false,
                    showSearchButton: true,
                    showSubscript: false,
                    showSuperscript: false,
                    showClipboardCut: false,
                    showClipboardCopy: false,
                    showClipboardPaste: false,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (viewModel.showToolbarOnTop) const Divider(height: 1),
      ],
    );
  }
}
