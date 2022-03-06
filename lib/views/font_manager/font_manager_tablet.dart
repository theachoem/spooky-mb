part of font_manager_view;

class _FontManagerTablet extends StatelessWidget {
  final FontManagerViewModel viewModel;
  const _FontManagerTablet(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('FontManagerTablet')),
    );
  }
}
