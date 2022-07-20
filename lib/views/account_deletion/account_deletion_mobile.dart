part of account_deletion_view;

class _AccountDeletionMobile extends StatelessWidget {
  final AccountDeletionViewModel viewModel;

  const _AccountDeletionMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    String? name = FirebaseAuth.instance.currentUser?.displayName;
    return Scaffold(
      appBar: MorphingAppBar(
        title: const SpAppBarTitle(fallbackRouter: SpRouter.accountDeletion),
      ),
      body: Consumer<NicknameProvider>(
        builder: (context, provider, child) {
          String nameToType = name ?? provider.name ?? "Delete account";
          nameToType = nameToType.trim();
          return ListView(
            children: [
              SpStepper(
                steps: [
                  buildStep1(),
                  buildStep2(context, nameToType),
                  buildStep3(nameToType, context),
                ],
                onStepPressed: (int step, int currentStep) async {
                  if (step == 2) {
                    return viewModel.validate(nameToType);
                  } else {
                    return true;
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }

  SpStep buildStep3(String nameToType, BuildContext context) {
    return SpStep(
      title: "Confirmation",
      subtitle: null,
      content: const SizedBox.shrink(),
      foregroundColor: (state) => M3Color.of(context).onError,
      backgroundColor: (state) => M3Color.of(context).error,
      buttonLabel: (state) {
        return "Perminently delete";
      },
      onPressed: (state) async {
        await viewModel.deleteAccount(context, nameToType);
        return state;
      },
    );
  }

  SpStep buildStep2(BuildContext context, String nameToType) {
    TextStyle? style = M3TextTheme.of(context).bodyMedium;
    return SpStep(
      title: "Verify deletion",
      subtitle: null,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MarkdownBody(
            styleSheet: MarkdownStyleSheet(
              textAlign: WrapAlignment.start,
              p: style,
              strong: style?.copyWith(fontWeight: FontWeight.bold),
            ),
            selectable: true,
            data: "Please type \"**$nameToType**\" to verify.",
          ),
          ConfigConstant.sizedBoxH2,
          buildVerifyTextField(nameToType),
        ],
      ),
      buttonLabel: (state) {
        switch (state) {
          case StepState.disabled:
          case StepState.error:
            return "Retry";
          case StepState.complete:
          case StepState.indexed:
          case StepState.editing:
            break;
        }
        return "Verify";
      },
      onPressed: (state) async {
        bool validated = viewModel.validate(nameToType);
        if (validated) {
          return StepState.complete;
        } else {
          return StepState.error;
        }
      },
    );
  }

  SpStep buildStep1() {
    return SpStep(
      title: "Agree with condition",
      subtitle: null,
      content: const Text(
        "Deleting this account will permanently delete your purchased add-ons that are associated.",
      ),
      buttonLabel: (state) {
        return "Agree";
      },
      onPressed: (state) async {
        return state;
      },
    );
  }

  TextFormField buildVerifyTextField(String nameToType) {
    return TextFormField(
      initialValue: viewModel.cacheLabel,
      onChanged: (text) {
        viewModel.cacheLabel = text;
      },
      decoration: InputDecoration(
        hintText: "Verify label...",
        errorText: viewModel.errorMessage,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
