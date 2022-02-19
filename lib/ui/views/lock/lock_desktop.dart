part of lock_view;

class _LockDesktop extends StatelessWidget {
  final LockViewModel viewModel;
  const _LockDesktop(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('LockDesktop')),
    );
  }
}
