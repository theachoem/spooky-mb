part of content_reader_view;

class _ContentReaderDesktop extends StatelessWidget {
  final ContentReaderViewModel viewModel;
  const _ContentReaderDesktop(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('ContentReaderDesktop')),
    );
  }
}
