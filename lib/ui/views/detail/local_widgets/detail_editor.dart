import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as editor;
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/mixins/stateful_mixin.dart';

class DetailEditor extends StatefulWidget {
  const DetailEditor({
    Key? key,
    required this.document,
    required this.readOnlyNotifier,
    required this.onControllerReady,
    required this.onFocusNodeReady,
    required this.onChange,
  }) : super(key: key);

  final List<dynamic>? document;
  final ValueNotifier<bool> readOnlyNotifier;
  final void Function(editor.QuillController controller) onControllerReady;
  final void Function(FocusNode focusNode) onFocusNodeReady;
  final void Function(editor.Document document) onChange;

  @override
  State<DetailEditor> createState() => _DetailEditorState();
}

class _DetailEditorState extends State<DetailEditor> with StatefulMixin {
  late editor.QuillController controller;
  late ScrollController scrollController;
  late FocusNode focusNode;

  @override
  void initState() {
    controller = _getDocumentController();
    scrollController = ScrollController();
    focusNode = FocusNode();
    super.initState();

    widget.onControllerReady(controller);
    widget.onFocusNodeReady(focusNode);

    controller.addListener(() {
      if (mounted) {
        widget.onChange(controller.document);
      }
    });
  }

  editor.QuillController _getDocumentController() {
    if (widget.document != null) {
      return editor.QuillController(
        document: editor.Document.fromJson(widget.document!),
        selection: const TextSelection.collapsed(offset: 0),
      );
    } else {
      return editor.QuillController.basic();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    scrollController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        buildEditor(),
        buildToolbarPositioned(),
      ],
    );
  }

  Widget buildEditor() {
    return Column(
      children: [
        ValueListenableBuilder<bool>(
          valueListenable: widget.readOnlyNotifier,
          builder: (context, value, child) {
            return editor.QuillEditor(
              controller: controller,
              scrollController: scrollController,
              scrollable: true,
              focusNode: focusNode,
              autoFocus: false,
              readOnly: widget.readOnlyNotifier.value,
              expands: false,
              padding: const EdgeInsets.all(ConfigConstant.margin2).copyWith(
                bottom: kToolbarHeight + MediaQuery.of(context).viewPadding.bottom + ConfigConstant.margin2,
              ),
              keyboardAppearance: M3Color.keyboardAppearance(context),
            );
          },
        ),
        buildAdditionBottomPadding(),
      ],
    );
  }

  Widget buildToolbarPositioned() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: ValueListenableBuilder<bool>(
        valueListenable: widget.readOnlyNotifier,
        child: AnimatedContainer(
          curve: Curves.ease,
          duration: ConfigConstant.duration * 2,
          color: M3Color.of(context).readOnly.surface2,
          padding: EdgeInsets.only(
            bottom: bottomHeight + keyboardHeight + ConfigConstant.margin0,
            top: ConfigConstant.margin0,
          ),
          child: buildQuillToolbar(),
        ),
        builder: (context, value, child) {
          return IgnorePointer(
            ignoring: value,
            child: AnimatedOpacity(
              opacity: value ? 0 : 1,
              duration: ConfigConstant.fadeDuration,
              curve: Curves.ease,
              child: AnimatedContainer(
                curve: Curves.ease,
                duration: ConfigConstant.fadeDuration,
                transform: Matrix4.identity()..translate(0.0, !value ? 0 : kToolbarHeight),
                child: child,
              ),
            ),
          );
        },
      ),
    );
  }

  editor.QuillToolbar buildQuillToolbar() {
    return editor.QuillToolbar.basic(
      controller: controller,
      multiRowsDisplay: false,
      toolbarIconSize: ConfigConstant.iconSize2,
    );
  }

  // spacing when toolbar is opened
  Widget buildAdditionBottomPadding() {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.readOnlyNotifier,
      builder: (context, value, child) {
        double height = value ? 0 : ConfigConstant.objectHeight1 + bottomHeight;
        return SizedBox(height: height + keyboardHeight);
      },
    );
  }
}
