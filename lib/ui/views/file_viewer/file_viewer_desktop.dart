part of file_viewer_view;

class _FileViewerDesktop extends StatelessWidget {
  final FileViewerViewModel viewModel;
  const _FileViewerDesktop(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('FileViewerDesktop')),
    );
  }
}
