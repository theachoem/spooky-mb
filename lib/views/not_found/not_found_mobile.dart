part of not_found_view;

class _NotFoundMobile extends StatelessWidget {
  final NotFoundViewModel viewModel;
  const _NotFoundMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(
        leading: ModalRoute.of(context)?.canPop == true ? const SpPopButton() : null,
        title: const SpAppBarTitle(fallbackRouter: SpRouter.notFound),
      ),
      body: const Center(
        child: Text("Not found"),
      ),
    );
  }
}
