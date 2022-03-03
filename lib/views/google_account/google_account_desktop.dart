part of google_account_view;

class _GoogleAccountDesktop extends StatelessWidget {
  final GoogleAccountViewModel viewModel;
  const _GoogleAccountDesktop(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('GoogleAccountDesktop')),
    );
  }
}
