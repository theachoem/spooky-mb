part of app_starter_view;

class _AppStarterMobile extends StatelessWidget {
  final AppStarterViewModel viewModel;
  const _AppStarterMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: M3Color.of(context).primary,
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).padding.bottom + ConfigConstant.margin2),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  'Spooky',
                  style: M3TextTheme.of(context).headlineLarge?.copyWith(color: M3Color.of(context).onPrimary),
                ),
              ),
            ),
            RichText(
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
                        style: M3TextTheme.of(context).bodyMedium?.copyWith(color: M3Color.of(context).onPrimary),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ConfigConstant.sizedBoxH2,
            SpButton(
              label: "Sign up & Accept",
              onTap: () {},
            )
          ],
        ),
      ),
    );
  }
}
