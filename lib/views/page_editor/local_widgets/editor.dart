part of '../page_editor_view.dart';

class _Editor extends StatelessWidget {
  final QuillController controller;
  final bool showToolbarOnBottom;
  final bool showToolbarOnTop;
  final VoidCallback toggleToolbarPosition;

  const _Editor({
    required this.controller,
    required this.showToolbarOnTop,
    required this.showToolbarOnBottom,
    required this.toggleToolbarPosition,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
          visible: showToolbarOnTop,
          child: SpFadeIn.fromBottom(
            duration: Durations.medium3,
            child: buildToolBar(),
          ),
        ),
        Expanded(child: buildPagesEditor()),
        Visibility(
          visible: showToolbarOnBottom,
          child: SpFadeIn.fromTop(
            duration: Durations.medium3,
            child: AnimatedContainer(
              duration: Durations.medium1,
              curve: Curves.ease,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + MediaQuery.of(context).viewInsets.bottom,
              ),
              child: buildToolBar(),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPagesEditor() {
    return QuillEditor.basic(
      controller: controller,
      configurations: const QuillEditorConfigurations(
        padding: EdgeInsets.all(16.0),
        autoFocus: true,
        enableScribble: true,
      ),
    );
  }

  Widget buildToolBar() {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      const Divider(height: 1),
      IntrinsicHeight(
        child: Row(children: [
          Expanded(
            child: QuillSimpleToolbar(
              controller: controller,
              configurations: QuillSimpleToolbarConfigurations(
                buttonOptions: QuillSimpleToolbarButtonOptions(
                  color: QuillToolbarColorButtonOptions(childBuilder: (options, extraOptions) {
                    return SpQuillToolbarColorButton(
                      controller: extraOptions.controller,
                      isBackground: false,
                      positionedOnUpper: showToolbarOnTop,
                    );
                  }),
                  backgroundColor: QuillToolbarColorButtonOptions(childBuilder: (options, extraOptions) {
                    return SpQuillToolbarColorButton(
                      controller: extraOptions.controller,
                      isBackground: true,
                      positionedOnUpper: showToolbarOnTop,
                    );
                  }),
                ),
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
          const VerticalDivider(width: 1),
          IconButton(
            icon: showToolbarOnTop ? const Icon(Icons.keyboard_arrow_down) : const Icon(Icons.keyboard_arrow_up),
            onPressed: () => toggleToolbarPosition(),
          ),
        ]),
      ),
      if (showToolbarOnTop) const Divider(height: 1),
    ]);
  }
}