part of app_starter_view;

class _AppStarterMobile extends StatelessWidget {
  final AppStarterViewModel viewModel;
  const _AppStarterMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: M3Color.of(context).primary,
      appBar: AppBar(
        systemOverlayStyle: M3Color.systemOverlayStyleFromBg(M3Color.of(context).primary),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          SpThemeSwitcher(
            backgroundColor: Colors.transparent,
            color: M3Color.of(context).onPrimary,
          ),
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(MediaQuery.of(context).padding.bottom + ConfigConstant.margin2),
        child: Text(
          'Spooky',
          style: M3TextTheme.of(context).headlineLarge?.copyWith(color: M3Color.of(context).onPrimary),
        ),
      ),
      bottomNavigationBar: buildBottomNavigation(context),
    );
  }

  Widget buildBottomNavigation(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        buildPolicyAlert(context),
        SizedBox(height: 16.0, width: double.infinity),
        buildSignUpButton(context),
        SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).padding.bottom + ConfigConstant.margin2,
        ),
      ],
    );
  }

  Widget buildSignUpButton(BuildContext context) {
    return SpButton(
      label: "Sign up & Accept",
      backgroundColor: M3Color.of(context).onPrimary,
      foregroundColor: M3Color.of(context).primary,
      onTap: () {
        Navigator.of(context).pushNamed(SpRouteConfig.nicknameCreator);
      },
    );
  }

  Widget buildPolicyAlert(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: M3TextTheme.of(context).bodyMedium?.copyWith(color: M3Color.of(context).onPrimary),
        children: [
          TextSpan(text: "By tapping on “Sign up & Accept”, you agree to the "),
          WidgetSpan(
            child: SpTapEffect(
              onTap: () {},
              child: Text(
                "Privacy Policy",
                style: M3TextTheme.of(context)
                    .bodyMedium
                    ?.copyWith(color: M3Color.of(context).onPrimary, decoration: TextDecoration.underline),
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
        currentColor: M3Color.currentPrimaryColor,
        onPickedColor: (color) async {
          callback();
          await Future.delayed(ConfigConstant.duration);
          await App.of(context)?.updateColor(color);
        },
      );
    }, childBuilder: (context, callback) {
      return SpIconButton(
        icon: Icon(Icons.palette, color: M3Color.of(context).onPrimary),
        onPressed: callback,
      );
    });
  }
}
