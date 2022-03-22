part of add_ons_view;

class _AddOnsTablet extends StatelessWidget {
  final AddOnsViewModel viewModel;
  const _AddOnsTablet(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('AddOnsTablet'),
      ),
    );
  }
}
