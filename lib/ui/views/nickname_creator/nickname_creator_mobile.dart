part of nickname_creator_view;

class _NicknameCreatorMobile extends StatelessWidget {
  final NicknameCreatorViewModel viewModel;
  const _NicknameCreatorMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        leading: SpPopButton(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(height: MediaQuery.of(context).viewInsets.bottom / 2),
          TextFormField(
            textAlign: TextAlign.center,
            autofocus: true,
            style: M3TextTheme.of(context).headlineLarge,
            decoration: InputDecoration(
              hintText: "Nickname",
              border: InputBorder.none,
              errorText: "",
            ),
            onChanged: (String value) => viewModel.nickname = value,
            initialValue: viewModel.nickname,
          ),
          ConfigConstant.sizedBoxH2,
          SpButton(
            label: "Continue",
            onTap: () {
              if (viewModel.nickname.trim().isNotEmpty) {
                // TODO: move to route name
                Navigator.of(context).push(SpPageRoute.sharedAxis(builder: (context) {
                  return InitPickColorView();
                }));
              } else {
                App.of(context)?.showSpSnackBar("Nickname must not empty!");
              }
            },
          ),
        ],
      ),
    );
  }
}
