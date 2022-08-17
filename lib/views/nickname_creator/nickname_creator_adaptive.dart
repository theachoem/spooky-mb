part of nickname_creator_view;

class _NicknameCreatorAdaptive extends StatelessWidget {
  final NicknameCreatorViewModel viewModel;
  const _NicknameCreatorAdaptive(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(
        systemOverlayStyle: M3Color.systemOverlayStyleFromBg(M3Color.of(context).background),
        backgroundColor: M3Color.of(context).background,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: Text(
          tr("page.nickname_creator.ask_for_name"),
          style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(color: M3Color.of(context).onBackground),
        ),
        actions: const [
          SpPopButton(forceCloseButton: true),
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
            hintText: tr("field.nickname.hint_text"),
            border: InputBorder.none,
            errorText: "",
          ),
        ),
      ),
      bottomNavigationBar: buildBottomNavigation(context),
    );
  }

  Widget buildBottomNavigation(BuildContext context) {
    return SpSingleButtonBottomNavigation(
      buttonLabel: tr("button.next"),
      onTap: () {
        if (viewModel.nickname.trim().isNotEmpty) {
          context.read<NicknameProvider>().setNickname(viewModel.nickname);
          MessengerService.instance.clearSnackBars();
          Navigator.of(context).pushNamed(
            SpRouter.initPickColor.path,
            arguments: const InitPickColorArgs(
              showNextButton: true,
            ),
          );
        } else {
          MessengerService.instance.showSnackBar(
            tr("field.nickname.validation.empty"),
          );
        }
      },
    );
  }
}
