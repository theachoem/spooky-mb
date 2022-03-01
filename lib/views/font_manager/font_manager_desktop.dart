part of font_manager_view;

class _FontManagerDesktop extends StatelessWidget {
  final FontManagerViewModel viewModel;
  const _FontManagerDesktop(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('FontManagerDesktop')),
    );
  }
}
