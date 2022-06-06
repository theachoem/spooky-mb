part of user_view;

class _UserTablet extends StatelessWidget {
  final UserViewModel viewModel;

  const _UserTablet(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('UserTablet')),
    );
  }
}
