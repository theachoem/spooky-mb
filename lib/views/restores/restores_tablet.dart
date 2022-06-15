part of restores_view;

class _RestoresTablet extends StatelessWidget {
  final RestoresViewModel viewModel;
  const _RestoresTablet(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('BackupsTablet')),
    );
  }
}
