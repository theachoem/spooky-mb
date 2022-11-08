part of explore_view;

class _BudgetsMobile extends StatelessWidget {
  final BudgetsViewModel viewModel;
  const _BudgetsMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('BudgetsMobile')),
    );
  }
}
