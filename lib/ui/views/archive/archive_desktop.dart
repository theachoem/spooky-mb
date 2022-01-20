part of archive_view;

class _ArchiveDesktop extends StatelessWidget {
  final ArchiveViewModel viewModel;
  const _ArchiveDesktop(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('ArchiveDesktop')),
    );
  }
}
