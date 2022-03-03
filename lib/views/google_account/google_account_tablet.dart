part of google_account_view;

class _GoogleAccountTablet extends StatelessWidget {
  final GoogleAccountViewModel viewModel;
  const _GoogleAccountTablet(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('GoogleAccountTablet')),
    );
  }
}
