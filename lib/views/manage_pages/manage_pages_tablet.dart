part of manage_pages_view;

class _ManagePagesTablet extends StatelessWidget {
  final ManagePagesViewModel viewModel;
  const _ManagePagesTablet(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('ManagePagesTablet')),
    );
  }
}
