part of not_found_view;

class _NotFoundMobile extends StatelessWidget {
  final NotFoundViewModel viewModel;
  const _NotFoundMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(
        leading: const SpPopButton(),
        title: const SpAppBarTitle(),
      ),
      body: Center(
        child: Text("Not found"),
      ),
    );
  }
}
