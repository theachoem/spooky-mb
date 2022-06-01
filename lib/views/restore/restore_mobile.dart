part of restore_view;

class _RestoreMobile extends StatelessWidget {
  final RestoreViewModel viewModel;
  const _RestoreMobile(this.viewModel);

  double get expandedHeight => 200;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        displacement: expandedHeight / 2,
        onRefresh: () => viewModel.load(),
        child: CustomScrollView(
          slivers: [
            buildAppBar(context),
            SliverPadding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + kToolbarHeight + 16.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  SpSectionsTiles.divide(
                    showTopDivider: true,
                    context: context,
                    sections: [
                      buildCloudServices(),
                      if (viewModel.loaded && viewModel.groupByYear?.isEmpty == true)
                        SpSectionContents(headline: "No backup found", tiles: []),
                      if (viewModel.groupByYear?.isNotEmpty == true) buildReviewSteps(),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  SpSectionContents buildReviewSteps() {
    return SpSectionContents(
      headline: "Restoring",
      tiles: [
        TweenAnimationBuilder<int>(
          duration: ConfigConstant.duration,
          tween: IntTween(begin: 0, end: 1),
          builder: (context, value, child) {
            return AnimatedOpacity(
              opacity: value == 1 ? 1 : 0,
              duration: ConfigConstant.duration * 2,
              child: buildStepper(context),
            );
          },
        ),
      ],
    );
  }

  Widget buildStepper(BuildContext context) {
    return SpStepper(
      onStepPressed: (int step, currentStep) async {
        bool empty = viewModel.downloadedByYear.isEmpty;
        if (step != 0 && empty) {
          MessengerService.instance.showSnackBar("Please complete current step!");
          return false;
        } else {
          return true;
        }
      },
      steps: [
        buildStep1(context),
        buildStep2(context),
      ],
    );
  }

  SpStep buildStep1(BuildContext context) {
    return SpStep(
      title: "Download backups",
      subtitle: "from your Drive",
      content: BackupChips(viewModel: viewModel, context: context),
      buttonLabel: (state) {
        switch (state) {
          case StepState.complete:
            if (viewModel.downloadedByYear.isEmpty) {
              return "Download";
            } else {
              return "Continue";
            }
          case StepState.error:
            return "Error";
          case StepState.editing:
          case StepState.indexed:
          case StepState.disabled:
          default:
            return "Download";
        }
      },
      onPressed: (state) async {
        switch (state) {
          case StepState.indexed:
            await viewModel.downloadAll();
            return StepState.complete;
          case StepState.complete:
            if (viewModel.downloadedByYear.isEmpty) await viewModel.downloadAll();
            return StepState.complete;
          case StepState.editing:
          case StepState.disabled:
          case StepState.error:
            return state;
        }
      },
    );
  }

  SpStep buildStep2(BuildContext context) {
    return SpStep(
      title: "Review & Restore",
      subtitle: "Click on any year to review",
      content: ReviewBackupChips(downloadedByYear: viewModel.downloadedByYear),
      buttonLabel: (state) {
        switch (state) {
          case StepState.complete:
            return "Done";
          case StepState.disabled:
          case StepState.editing:
          case StepState.indexed:
          case StepState.error:
          default:
            return "Restore";
        }
      },
      onPressed: (state) async {
        switch (state) {
          case StepState.indexed:
            await viewModel.restore(context, viewModel.downloadedByYear);
            return StepState.complete;
          case StepState.complete:
            if (viewModel.showSkipButton) {
              Navigator.of(context).pushNamedAndRemoveUntil(SpRouter.main.path, (_) => false);
              return StepState.complete;
            } else {
              Navigator.of(context).pop();
              return StepState.complete;
            }
          case StepState.disabled:
          case StepState.error:
          case StepState.editing:
          default:
            return state;
        }
      },
    );
  }

  SpSectionContents buildCloudServices() {
    return SpSectionContents(
      headline: "Cloud Service",
      tiles: [
        GoogleAccountTile(
          onSignOut: () {
            viewModel.load();
          },
          onSignIn: () {
            viewModel.load();
          },
        ),
        SpCrossFade(
          showFirst: !viewModel.loaded,
          firstChild: const LinearProgressIndicator(),
          secondChild: const SizedBox(width: double.infinity),
        ),
      ],
    );
  }

  Widget buildAppBar(BuildContext context) {
    return SpExpandedAppBar(
      expandedHeight: expandedHeight,
      backgroundColor: M3Color.of(context).background,
      actions: [
        if (viewModel.showSkipButton)
          ValueListenableBuilder(
            valueListenable: viewModel.showSkipNotifier,
            builder: (context, value, child) {
              return SpCrossFade(
                showFirst: !viewModel.showSkipNotifier.value,
                firstChild: const SizedBox.shrink(),
                secondChild: Center(
                  child: SpButton(
                    label: "Skip",
                    backgroundColor: Colors.transparent,
                    foregroundColor: Theme.of(context).appBarTheme.titleTextStyle?.color,
                    onTap: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(SpRouter.main.path, (_) => false);
                    },
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
