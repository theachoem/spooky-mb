part of nickname_creator_view;

class _NicknameCreatorMobile extends StatelessWidget {
  final NicknameCreatorViewModel viewModel;
  const _NicknameCreatorMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(
        systemOverlayStyle: M3Color.systemOverlayStyleFromBg(M3Color.of(context).background),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: Text(
          "So, what's your nickname?",
          style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(color: M3Color.of(context).onBackground),
        ),
        actions: [
          SpIconButton(
            icon: Icon(Icons.clear),
            onPressed: () => Navigator.maybePop(context),
          ),
        ],
      ),
      body: Center(
        child: TextFormField(
          textAlign: TextAlign.center,
          autofocus: true,
          style: M3TextTheme.of(context).headlineLarge,
          onChanged: (String value) => viewModel.nickname = value,
          initialValue: viewModel.nickname,
          decoration: InputDecoration(
            hintText: "Nickname",
            border: InputBorder.none,
            errorText: "",
          ),
        ),
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
            onTap: () {
              if (viewModel.nickname.trim().isNotEmpty) {
                App.of(context)?.setNickname(viewModel.nickname);
                App.of(context)?.clearSpSnackBars();
                Navigator.of(context).pushNamed(SpRouteConfig.initPickColor);
              } else {
                App.of(context)?.showSpSnackBar("Nickname must not empty!");
              }
            },
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
