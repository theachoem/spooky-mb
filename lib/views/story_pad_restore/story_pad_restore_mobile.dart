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
              AppHelper.openLinkDialog(AppConstant.customerSupport);
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
            title: "Enter backup url",
            subtitle: null,
            content: Column(
              children: [
                const Text('In Google Drive. "Story" folder, find a zip file & paste its url here.'),
                ConfigConstant.sizedBoxH2,
                TextField(
                  onChanged: (value) => viewModel.url = value,
                  decoration: const InputDecoration(
                    hintText: "Backup url...",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            buttonLabel: (state) => "Contnue",
            onPressed: (state) async {
              return state;
            },
          ),
          SpStep(
            title: "Download & Validate",
            subtitle: 'Check if input url is valid',
            content: const SizedBox.shrink(),
            buttonLabel: (state) => "Validate",
            onPressed: (state) async {
              await viewModel.load();
              return state;
            },
          ),
          SpStep(
            title: "Review",
            subtitle: "Make sure stories are correct",
            content: const SizedBox.shrink(),
            buttonLabel: (state) => "Review",
            onPressed: (state) async {
              BottomSheetService.instance.showScrollableSheet(
                context: App.navigatorKey.currentContext ?? context,
                title: "StoryPad",
                builder: (context, controller) {
                  return StoryList(
                    viewOnly: true,
                    controller: controller,
                    onRefresh: () async {},
                    stories: viewModel.stories,
                    overridedLayout: ListLayoutType.single,
                  );
                },
              );
              return state;
            },
          ),
          SpStep(
            title: "Restore",
            subtitle: "Write them to Spooky",
            content: const SizedBox.shrink(),
            buttonLabel: (state) {
              switch (state) {
                case StepState.complete:
                  return "Done";
                case StepState.disabled:
                case StepState.error:
                case StepState.indexed:
                case StepState.editing:
                  return "Restore";
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
