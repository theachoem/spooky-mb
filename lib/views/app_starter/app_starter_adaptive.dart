part of app_starter_view;

class _AppStarterAdaptive extends StatelessWidget {
  final AppStarterViewModel viewModel;
  const _AppStarterAdaptive(this.viewModel);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Theme.of(context).colorScheme.primary;
    Color foregroundColor = Theme.of(context).colorScheme.onPrimary;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        systemOverlayStyle: M3Color.systemOverlayStyleFromBg(M3Color.of(context).primary),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          SpThemeSwitcher(
            backgroundColor: Colors.transparent,
            color: foregroundColor,
          ),
        ],
      ),
      bottomNavigationBar: buildBottomNavigation(context),
      body: buildBody(foregroundColor, context),
    );
  }

  Widget buildBody(Color foregroundColor, BuildContext context) {
    return Stack(
      children: [
        _StartContent(foregroundColor: foregroundColor),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: _BottomNavWave(context: context),
        )
      ],
    );
  }

  Widget buildBottomNavigation(BuildContext context) {
    return Material(
      color: Theme.of(context).appBarTheme.backgroundColor,
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          const SizedBox(width: double.infinity, height: ConfigConstant.margin2 * 2),
          buildPolicyAlert(context),
          const SizedBox(height: 16.0, width: double.infinity),
          buildSignUpButton(context),
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).padding.bottom + ConfigConstant.margin2,
          ),
        ],
      ),
    );
  }

  Widget buildSignUpButton(BuildContext context) {
    return SpButton(
      label: tr("button.accept"),
      backgroundColor: M3Color.of(context).primary,
      foregroundColor: M3Color.of(context).onPrimary,
      onTap: () {
        Navigator.of(context).pushNamed(SpRouter.nicknameCreator.path);
      },
    );
  }

  Widget buildPolicyAlert(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: M3TextTheme.of(context).bodyMedium?.copyWith(color: M3Color.of(context).onBackground),
        children: [
          const TextSpan(text: "By tapping on “Sign up & Accept”, you agree to the "),
          WidgetSpan(
            child: SpTapEffect(
              onTap: () {
                AppHelper.openLinkDialog(AppConstant.privacyPolicy);
              },
              child: Text(
                "Privacy Policy",
                style: M3TextTheme.of(context)
                    .bodyMedium
                    ?.copyWith(color: M3Color.of(context).onBackground, decoration: TextDecoration.underline),
              ),
            ),
          ),
        ],
      ),
    );
  }

  SpOverlayEntryButton buildColorPickerButton() {
    return SpOverlayEntryButton(floatingBuilder: (context, callback) {
      return SpColorPicker(
        blackWhite: SpColorPicker.getBlackWhite(context),
        currentColor: context.read<ThemeProvider>().colorSeed,
        onPickedColor: (color) async {
          callback();
          Future.delayed(ConfigConstant.duration).then((value) async {
            await context.read<ThemeProvider>().updateColor(color);
          });
        },
      );
    }, childBuilder: (context, key, callback) {
      return SpIconButton(
        key: key,
        icon: Icon(Icons.palette, color: M3Color.of(context).onPrimary),
        onPressed: callback,
      );
    });
  }
}

class _BottomNavWave extends StatelessWidget {
  const _BottomNavWave({
    Key? key,
    required this.context,
  }) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    Color foregroundColor = Theme.of(context).appBarTheme.backgroundColor!;
    return SizedBox(
      height: kToolbarHeight,
      child: WaveWidget(
        backgroundColor: Colors.transparent,
        config: CustomConfig(
          gradients: [
            [foregroundColor.withOpacity(1), foregroundColor.withOpacity(0.5)],
            [foregroundColor.withOpacity(0.5), foregroundColor.withOpacity(1)],
            [foregroundColor.withOpacity(1), foregroundColor.withOpacity(0.5)],
            [foregroundColor.withOpacity(0.5), foregroundColor.withOpacity(1)]
          ],
          durations: [35000, 19440, 10800, 6000],
          heightPercentages: [0.5, 0.55, 0.6, 0.65],
          gradientBegin: Alignment.bottomLeft,
          gradientEnd: Alignment.topRight,
        ),
        waveAmplitude: 0,
        size: const Size(
          double.infinity,
          double.infinity,
        ),
      ),
    );
  }
}

class _StartContent extends StatelessWidget {
  const _StartContent({
    Key? key,
    required this.foregroundColor,
  }) : super(key: key);

  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 200),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Spooky',
              style: M3TextTheme.of(context).headlineLarge?.copyWith(color: foregroundColor),
              textAlign: TextAlign.center,
            ),
            ConfigConstant.sizedBoxH2,
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: M3TextTheme.of(context).bodyMedium?.copyWith(color: foregroundColor),
                children: [
                  const TextSpan(
                    text: "Express yourself freely and safely",
                  ),
                  WidgetSpan(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Icon(
                        CommunityMaterialIcons.ghost,
                        size: ConfigConstant.iconSize1,
                        color: foregroundColor,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
