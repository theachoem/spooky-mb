part of lock_view;

class _LockMobile extends StatelessWidget {
  final LockViewModel viewModel;
  const _LockMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('LockMobile')),
    );
  }
}
