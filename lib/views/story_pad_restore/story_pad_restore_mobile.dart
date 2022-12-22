part of story_pad_restore_view;

class _StoryPadRestoreMobile extends StatelessWidget {
  final StoryPadRestoreViewModel viewModel;
  const _StoryPadRestoreMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(
        title: const SpAppBarTitle(fallbackRouter: SpRouter.storyPadRestore),
        leading: const SpPopButton(),
        actions: [
          SpIconButton(
            icon: const Icon(CommunityMaterialIcons.chat_question),
            onPressed: () {
              AppHelper.openLinkDialog(RemoteConfigStringKeys.linkToCustomerSupport.get());
            },
          ),
        ],
      ),
      body: SpStepper(
        onStepPressed: (step, currentStep) async {
          return currentStep > step;
        },
        steps: [
          SpStep(
            title: tr("step.migrate_storypad.step1.title"),
            subtitle: null,
            content: Column(
              children: [
                Text(tr("step.migrate_storypad.step1.message")),
                ConfigConstant.sizedBoxH2,
                TextField(
                  onChanged: (value) => viewModel.url = value,
                  decoration: InputDecoration(
                    hintText: tr("field.backup_url.hint_text"),
                    border: const OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            buttonLabel: (state) => tr("button.continue"),
            onPressed: (state) async {
              return state;
            },
          ),
          SpStep(
            title: tr("step.migrate_storypad.step2.title"),
            subtitle: tr("step.migrate_storypad.step2.subtitle"),
            content: const SizedBox.shrink(),
            buttonLabel: (state) => tr("button.validate"),
            onPressed: (state) async {
              await viewModel.load();
              return state;
            },
          ),
          SpStep(
            title: tr("step.migrate_storypad.step3.title"),
            subtitle: tr("step.migrate_storypad.step3.subtitle"),
            content: const SizedBox.shrink(),
            buttonLabel: (state) => tr("button.review"),
            onPressed: (state) async {
              BottomSheetService.instance.showScrollableSheet(
                context: App.navigatorKey.currentContext ?? context,
                title: tr("alert.storypad_list.title"),
                builder: (context, controller) {
                  return SpStoryList(
                    overridedLayout: SpListLayoutType.timeline,
                    stories: viewModel.stories,
                    viewOnly: true,
                    controller: controller,
                    onRefresh: () async {},
                  );
                },
              );
              return state;
            },
          ),
          SpStep(
            title: tr("step.migrate_storypad.step4.title"),
            subtitle: tr("step.migrate_storypad.step4.title"),
            content: const SizedBox.shrink(),
            buttonLabel: (state) {
              switch (state) {
                case StepState.complete:
                  return tr("button.done");
                case StepState.disabled:
                case StepState.error:
                case StepState.indexed:
                case StepState.editing:
                  return tr("button.restore");
              }
            },
            onPressed: (state) async {
              switch (state) {
                case StepState.indexed:
                  await viewModel.restore();
                  return StepState.complete;
                case StepState.complete:
                  Navigator.of(context).pop();
                  return state;
                case StepState.editing:
                case StepState.disabled:
                case StepState.error:
                  return state;
              }
            },
          ),
        ],
      ),
    );
  }
}
