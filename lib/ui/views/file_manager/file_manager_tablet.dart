part of file_manager_view;

class _FileManagerTablet extends StatelessWidget {
  final FileManagerViewModel viewModel;
  const _FileManagerTablet(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('FileManagerTablet')),
    );
  }
}
