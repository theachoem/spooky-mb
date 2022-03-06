part of manage_pages_view;

class _ManagePagesDesktop extends StatelessWidget {
  final ManagePagesViewModel viewModel;
  const _ManagePagesDesktop(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('ManagePagesDesktop')),
    );
  }
}
