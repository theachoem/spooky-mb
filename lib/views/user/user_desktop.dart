part of user_view;

class _UserDesktop extends StatelessWidget {
  final UserViewModel viewModel;
  const _UserDesktop(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('UserDesktop')),
    );
  }
}
