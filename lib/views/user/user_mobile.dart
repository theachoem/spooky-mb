part of user_view;

class _UserMobile extends StatelessWidget {
  final UserViewModel viewModel;
  const _UserMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('UserMobile')),
    );
  }
}
