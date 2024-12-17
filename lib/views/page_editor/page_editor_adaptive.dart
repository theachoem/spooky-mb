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
      ),
      body: buildBody(context),
      bottomNavigationBar: viewModel.controller == null ? null : buildPagesEditorToolbar(context),
    );
  }

  Widget buildBody(BuildContext context) {
    if (viewModel.controller == null) {
      return const Center(child: CircularProgressIndicator.adaptive());
    } else {
      return buildPagesEditor();
    }
  }

  Widget buildPagesEditorToolbar(BuildContext context) {
    return AnimatedContainer(
      duration: Durations.medium1,
      curve: Curves.ease,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + MediaQuery.of(context).viewInsets.bottom,
      ),
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
    );
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
}
