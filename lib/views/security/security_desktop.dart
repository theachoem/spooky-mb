part of security_view;

class _SecurityDesktop extends StatelessWidget {
  final SecurityViewModel viewModel;
  const _SecurityDesktop(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('SecurityDesktop')),
    );
  }
}
