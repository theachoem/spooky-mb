part of account_deletion_view;

class _AccountDeletionMobile extends StatelessWidget {
  final AccountDeletionViewModel viewModel;

  const _AccountDeletionMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    String? name = FirebaseAuth.instance.currentUser?.displayName;
    return Scaffold(
      appBar: MorphingAppBar(
        leading: const SpPopButton(forceCloseButton: true),
        title: const SpAppBarTitle(fallbackRouter: SpRouter.accountDeletion),
      ),
      body: Consumer<NicknameProvider>(
        builder: (context, provider, child) {
          String nameToType = name ?? provider.name ?? tr("msg.account_deletion");
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
      title: tr("step.delete_account.step3.title"),
      subtitle: null,
      content: const SizedBox.shrink(),
      foregroundColor: (state) => M3Color.of(context).onError,
      backgroundColor: (state) => M3Color.of(context).error,
      buttonLabel: (state) {
        return tr("button.perminently_delete");
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
      title: tr("step.delete_account.step2.title"),
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
            data: tr(
              "step.delete_account.step2.message",
              namedArgs: {"NAME": nameToType},
            ),
          ),
          ConfigConstant.sizedBoxH2,
          buildVerifyTextField(nameToType),
        ],
      ),
      buttonLabel: (state) {
        switch (state) {
          case StepState.disabled:
          case StepState.error:
            return tr("button.retry");
          case StepState.complete:
          case StepState.indexed:
          case StepState.editing:
            break;
        }
        return tr("button.verify");
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
      title: tr("step.delete_account.step1.title"),
      subtitle: null,
      content: Text(tr("step.delete_account.step1.message")),
      buttonLabel: (state) {
        return tr("button.agree");
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
        hintText: tr("field.verify_name.hint_text"),
        errorText: viewModel.errorMessage,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
