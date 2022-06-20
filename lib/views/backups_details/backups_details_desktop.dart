part of backups_details_view;

class _BackupsDetailsDesktop extends StatelessWidget {
  final BackupsDetailsViewModel viewModel;
  const _BackupsDetailsDesktop(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('BackupsDetailsDesktop')),
    );
  }
}
