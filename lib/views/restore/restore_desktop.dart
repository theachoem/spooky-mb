part of restore_view;

class _RestoreDesktop extends StatelessWidget {
  final RestoreViewModel viewModel;
  const _RestoreDesktop(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('RestoreDesktop')),
    );
  }
}
