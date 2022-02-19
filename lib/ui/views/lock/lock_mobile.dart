part of lock_view;

class _LockMobile extends StatelessWidget {
  final LockViewModel viewModel;
  const _LockMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(
        title: Text(
          "Lock",
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Enter your password"),
          TextFormField(
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.continueAction,
            textAlign: TextAlign.center,
            autofocus: true,
            style: M3TextTheme.of(context).headlineLarge,
            onChanged: (String value) {},
            initialValue: "",
            decoration: InputDecoration(
              hintText: "------",
              border: InputBorder.none,
              errorText: "",
            ),
          ),
        ],
      ),
      bottomNavigationBar: buildBottomNavigation(context),
    );
  }

  Widget buildBottomNavigation(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SpButton(
            label: "Done",
            onTap: () {},
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).padding.bottom + ConfigConstant.margin2,
        ),
      ],
    );
  }
}
