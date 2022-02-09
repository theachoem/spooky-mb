part of nickname_creator_view;

class _NicknameCreatorMobile extends StatelessWidget {
  final NicknameCreatorViewModel viewModel;
  const _NicknameCreatorMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: MorphingAppBar(
        systemOverlayStyle: M3Color.systemOverlayStyleFromBg(M3Color.of(context).background),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: SpPopButton(),
        title: Text(
          "So, what's your nickname?",
          style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(color: M3Color.of(context).onBackground),
        ),
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
            label: "Done",
            onTap: () {
              if (viewModel.nickname.trim().isNotEmpty) {
                App.of(context)?.clearSpSnackBars();
                Navigator.of(context).pushNamedAndRemoveUntil(SpRouteConfig.main, (_) => false);
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
