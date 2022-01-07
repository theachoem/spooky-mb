part of file_manager_view;

class _FileManagerMobile extends StatelessWidget {
  final FileManagerViewModel viewModel;
  const _FileManagerMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('FileManagerMobile')),
    );
  }
}
