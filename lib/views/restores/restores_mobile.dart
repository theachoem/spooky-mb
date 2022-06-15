part of restores_view;

class _RestoresMobile extends StatelessWidget {
  final RestoresViewModel viewModel;
  const _RestoresMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('BackupsMobile')),
    );
  }
}
