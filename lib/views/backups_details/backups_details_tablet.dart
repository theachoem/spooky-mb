part of backups_details_view;

class _BackupsDetailsTablet extends StatelessWidget {
  final BackupsDetailsViewModel viewModel;
  const _BackupsDetailsTablet(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('BackupsDetailsTablet')),
    );
  }
}
