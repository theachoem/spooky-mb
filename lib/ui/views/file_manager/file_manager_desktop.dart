part of file_manager_view;

class _FileManagerDesktop extends StatelessWidget {
  final FileManagerViewModel viewModel;
  const _FileManagerDesktop(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('FileManagerDesktop')),
    );
  }
}
