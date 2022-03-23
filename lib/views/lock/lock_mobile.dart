part of lock_view;

class _LockMobile extends StatelessWidget {
  final LockViewModel viewModel;
  const _LockMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(
        leading: ModalRoute.of(context)?.canPop == true ? const SpPopButton() : null,
        title: const SpAppBarTitle(fallbackRouter: SpRouter.lock),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Enter your password"),
          TextFormField(
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.continueAction,
            textAlign: TextAlign.center,
            autofocus: true,
            style: M3TextTheme.of(context).headlineLarge,
            onChanged: (String value) {},
            initialValue: "",
            decoration: const InputDecoration(
              hintText: "------",
              border: InputBorder.none,
              errorText: "",
            ),
          ),
        ],
      ),
      bottomNavigationBar: SpSingleButtonBottomNavigation(
        buttonLabel: "Done",
        onTap: () {},
      ),
    );
  }
}
