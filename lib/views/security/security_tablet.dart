part of security_view;

class _SecurityTablet extends StatelessWidget {
  final SecurityViewModel viewModel;
  const _SecurityTablet(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('SecurityTablet')),
    );
  }
}
