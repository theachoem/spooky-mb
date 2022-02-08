part of init_pick_color_view;

class _InitPickColorTablet extends StatelessWidget {
  final InitPickColorViewModel viewModel;
  const _InitPickColorTablet(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('InitPickColorTablet')),
    );
  }
}
