part of restore_view;

class _RestoreTablet extends StatelessWidget {
  final RestoreViewModel viewModel;
  const _RestoreTablet(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('RestoreTablet')),
    );
  }
}
