part of restore_view;

class _RestoreMobile extends StatelessWidget {
  final RestoreViewModel viewModel;
  const _RestoreMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('RestoreMobile')),
    );
  }
}
