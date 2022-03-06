part of lock_view;

class _LockTablet extends StatelessWidget {
  final LockViewModel viewModel;
  const _LockTablet(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('LockTablet')),
    );
  }
}
