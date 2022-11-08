part of explore_view;

class _BudgetsMobile extends StatelessWidget {
  final BudgetsViewModel viewModel;
  const _BudgetsMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        floatingActionButton: ValueListenableBuilder<double>(
          valueListenable: viewModel.offsetNotifier,
          builder: (context, offset, child) {
            bool activeTransactionPage = offset < 0.75;
            return SpScaleIn(
              transformAlignment: Alignment.center,
              child: SpShowHideAnimator(
                shouldShow: activeTransactionPage,
                child: FloatingActionButton(
                  backgroundColor: M3Color.of(context).tertiaryContainer,
                  onPressed: () {},
                  child: const Icon(Icons.add),
                ),
              ),
            );
          },
        ),
        appBar: buildAppBar(context),
        body: SpTabView(
          listener: (controller) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              viewModel.offsetNotifier.value = controller.animation?.value ?? 0.0;
            });
          },
          children: const [
            BudgetsTransactions(),
            BudgetsPlans(),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      actions: [
        SpIconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {},
        ),
      ],
      title: SpTapEffect(
        onTap: () {
          SpDatePicker.showPicker(
            context: context,
            dateFormat: 'yyyy-MMMM',
          );
        },
        child: RichText(
          text: TextSpan(
            style: Theme.of(context).appBarTheme.titleTextStyle,
            text: "November",
            children: const [
              WidgetSpan(
                child: Icon(Icons.arrow_drop_down),
              ),
            ],
          ),
        ),
      ),
      bottom: const TabBar(
        tabs: [
          Tab(
            text: "Transactions",
          ),
          Tab(
            text: "Plans",
          ),
        ],
      ),
    );
  }
}
