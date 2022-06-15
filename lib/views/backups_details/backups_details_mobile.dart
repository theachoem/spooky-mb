part of backups_details_view;

class _BackupsDetailsMobile extends StatelessWidget {
  final BackupsDetailsViewModel viewModel;
  const _BackupsDetailsMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('BackupsDetailsMobile')),
    );
  }
}
