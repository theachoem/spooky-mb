part of archive_view;

class _ArchiveTablet extends StatelessWidget {
  final ArchiveViewModel viewModel;
  const _ArchiveTablet(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('ArchiveTablet')),
    );
  }
}
