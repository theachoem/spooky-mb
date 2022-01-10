part of detail_view;

class _DetailMobile extends StatelessWidget {
  final DetailViewModel viewModel;
  const _DetailMobile(this.viewModel);

  ValueNotifier<bool> get readOnlyNotifier => viewModel.readOnlyNotifier;
  TextEditingController get titleController => viewModel.titleController;
  ValueNotifier<bool> get hasChangeNotifer => viewModel.hasChangeNotifer;
  List<List<dynamic>> get documents {
    List<List<dynamic>>? pages = viewModel.currentStory.pages;
    return pages ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return DetailScaffold(
      titleBuilder: (state) => buildTitle(state),
      editorBuilder: (state) => buildEditor(state, context),
      readOnlyNotifier: readOnlyNotifier,
      hasChangeNotifer: hasChangeNotifer,
      onSave: (context) => viewModel.save(context),
      viewModel: viewModel,
    );
  }

  Widget buildEditor(GlobalKey<ScaffoldState> state, BuildContext context) {
    if (documents.isEmpty) return Text("No documents found");
    return Stack(
      children: [
        PageView.builder(
          itemCount: documents.length,
          controller: viewModel.pageController,
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
        ),
        IgnorePointer(
          child: ValueListenableBuilder<bool>(
            valueListenable: readOnlyNotifier,
            child: indicator.SmoothPageIndicator(
              controller: viewModel.pageController,
              effect: indicator.WormEffect(dotHeight: 4),
              count: documents.length,
            ),
            builder: (context, value, child) {
              MediaQueryData? mediaQueryData = MediaQuery.of(context);
              double keyboardHeight = mediaQueryData.viewInsets.bottom;
              double bottomHeight = mediaQueryData.viewPadding.bottom;
              double bottom = (value ? 0 : kToolbarHeight) + bottomHeight + 16.0 + 16.0 + 2.0;
              return AnimatedOpacity(
                curve: Curves.fastOutSlowIn,
                opacity: keyboardHeight == 0 ? 1 : 0,
                duration: Duration(seconds: 1),
                child: Container(
                  margin: EdgeInsets.only(bottom: bottom),
                  alignment: Alignment.bottomCenter,
                  child: child,
                ),
              );
            },
          ),
        )
      ],
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
