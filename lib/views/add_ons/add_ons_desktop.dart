part of add_ons_view;

class _AddOnsDesktop extends StatelessWidget {
  final AddOnsViewModel viewModel;
  const _AddOnsDesktop(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('AddOnsDesktop')),
    );
  }
}
