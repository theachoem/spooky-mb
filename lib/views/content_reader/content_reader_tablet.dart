part of content_reader_view;

class _ContentReaderTablet extends StatelessWidget {
  final ContentReaderViewModel viewModel;
  const _ContentReaderTablet(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('ContentReaderTablet')),
    );
  }
}
