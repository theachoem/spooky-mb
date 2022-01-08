part of file_viewer_view;

class _FileViewerTablet extends StatelessWidget {
  final FileViewerViewModel viewModel;
  const _FileViewerTablet(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('FileViewerTablet')),
    );
  }
}
