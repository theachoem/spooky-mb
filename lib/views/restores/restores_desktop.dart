part of restores_view;

class _RestoresDesktop extends StatelessWidget {
  final RestoresViewModel viewModel;
  const _RestoresDesktop(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('BackupsDesktop')),
    );
  }
}
