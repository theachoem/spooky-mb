part of font_manager_view;

class _FontManagerMobile extends StatelessWidget {
  final FontManagerViewModel viewModel;
  const _FontManagerMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(
        leading: SpPopButton(),
        title: Text(
          "Theme",
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: ListView(),
    );
  }
}
