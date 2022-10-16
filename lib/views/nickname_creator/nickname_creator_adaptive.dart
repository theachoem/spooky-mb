part of nickname_creator_view;

class _NicknameCreatorAdaptive extends StatelessWidget {
  final NicknameCreatorViewModel viewModel;
  const _NicknameCreatorAdaptive(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(
        backgroundColor: M3Color.of(context).background,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: const SizedBox.shrink(),
        centerTitle: false,
        flexibleSpace: FlexibleSpaceBar(
          title: buildTitle(),
          centerTitle: false,
          titlePadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        ),
        actions: const [
          SpPopButton(forceCloseButton: true),
        ],
      ),
      bottomNavigationBar: const SizedBox(height: kToolbarHeight),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: buildFab(),
      body: buildBody(),
    );
  }

  Widget buildTitle() {
    return FutureBuilder<int>(
      future: viewModel.completer.future,
      builder: (context, snapshot) {
        return Visibility(
          visible: snapshot.data == 1,
          child: SpFadeIn(
            child: Text(
              tr("page.nickname_creator.ask_for_name"),
              style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(color: M3Color.of(context).onBackground),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
            ),
          ),
        );
      },
    );
  }

  Widget buildFab() {
    return FutureBuilder<int>(
      future: viewModel.completer.future.then((value) => Future.delayed(ConfigConstant.duration).then((_) => value)),
      builder: (context, snapshot) {
        return Visibility(
          visible: snapshot.data == 1,
          child: SpFadeIn(
            duration: ConfigConstant.fadeDuration * 2,
            child: SpButton(
              label: tr("button.next"),
              onTap: () => onNext(context),
            ),
          ),
        );
      },
    );
  }

  Widget buildBody() {
    return FutureBuilder<int>(
      future: viewModel.completer.future,
      builder: (context, snapshot) {
        return Visibility(
          visible: snapshot.data == 1,
          child: SpFadeIn(
            child: SpScaleIn(
              curve: Curves.fastLinearToSlowEaseIn,
              duration: ConfigConstant.fadeDuration ~/ 2,
              transformAlignment: Alignment.center,
              child: Center(
                child: TextFormField(
                  textAlign: TextAlign.center,
                  autofocus: true,
                  style: M3TextTheme.of(context).headlineLarge,
                  onChanged: (String value) => viewModel.nicknameNotifier.value = value,
                  initialValue: viewModel.nicknameNotifier.value,
                  decoration: InputDecoration(
                    hintText: tr("field.nickname.hint_text"),
                    border: InputBorder.none,
                    errorText: "",
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void onNext(BuildContext context) {
    if (viewModel.nicknameNotifier.value.isNotEmpty) {
      context.read<NicknameProvider>().setNickname(viewModel.nicknameNotifier.value);
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
  }
}
