part of google_account_view;

class _GoogleAccountMobile extends StatelessWidget {
  final GoogleAccountViewModel viewModel;
  const _GoogleAccountMobile(this.viewModel);

  GoogleSignInAccount? get user => viewModel.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(
        leading: SpPopButton(),
        title: Text(
          "Google Account",
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: ListView(
        children: [
          buildAccountTile(),
          SpButton(
            label: "Text",
            onTap: () {
              viewModel.driveService.fetchAll();
            },
          )
        ],
      ),
    );
  }

  Widget buildAccountTile() {
    if (user != null) {
      return ListTile(
        title: Text(user!.displayName ?? ""),
      );
    } else {
      return ListTile(
        title: Text("Sign In"),
        trailing: Icon(Icons.keyboard_arrow_right),
        onTap: () {
          viewModel.signIn();
        },
      );
    }
  }
}
