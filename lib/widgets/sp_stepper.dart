import 'package:flutter/material.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/widgets/sp_button.dart';

class SpStep {
  final String title;
  final String? subtitle;
  final Widget content;
  final String Function(StepState) buttonLabel;
  final Future<StepState> Function(StepState) onPressed;
  final Color? Function(StepState)? backgroundColor;
  final Color? Function(StepState)? foregroundColor;

  SpStep({
    required this.title,
    required this.subtitle,
    required this.content,
    required this.buttonLabel,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
  });
}

class SpStepper extends StatefulWidget {
  const SpStepper({
    Key? key,
    required this.steps,
    required this.onStepPressed,
  }) : super(key: key);

  final List<SpStep> steps;
  final Future<bool> Function(int step, int currentStep) onStepPressed;

  @override
  State<SpStepper> createState() => _SpStepperState();
}

class _SpStepperState extends State<SpStepper> {
  int currentStep = 0;
  Map<int, StepState> states = {};

  StepState? getStepState(int index) => states[index];
  void setStepState(int index, StepState state) {
    setState(() {
      states[index] = state;
    });
  }

  void setCurrentStep(int index) {
    setState(() {
      currentStep = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      removeTop: true,
      removeBottom: true,
      context: context,
      child: Stepper(
        physics: const ScrollPhysics(),
        onStepTapped: (index) async {
          if (index == currentStep) return;
          bool allowed = await widget.onStepPressed(index, currentStep);
          if (allowed) setCurrentStep(index);
        },
        currentStep: currentStep,
        controlsBuilder: (context, details) {
          final step = widget.steps[details.stepIndex];
          final state = getStepState(details.stepIndex) ?? StepState.indexed;
          return Padding(
            padding: const EdgeInsets.only(top: ConfigConstant.margin1),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                SpButton(
                  backgroundColor: step.backgroundColor != null ? step.backgroundColor!(state) : null,
                  foregroundColor: step.backgroundColor != null ? step.foregroundColor!(state) : null,
                  loading: state == StepState.editing,
                  label: step.buttonLabel(state),
                  onTap: () async {
                    setStepState(details.stepIndex, StepState.editing);
                    final nextState = await step.onPressed(state);
                    setStepState(details.stepIndex, nextState);
                    if (details.stepIndex == widget.steps.length - 1) return;
                    if (nextState != StepState.error) {
                      setCurrentStep(details.stepIndex + 1);
                    }
                  },
                ),
              ],
            ),
          );
        },
        steps: List.generate(widget.steps.length, (index) {
          final e = widget.steps[index];
          return Step(
            isActive: index == currentStep,
            title: Text(e.title),
            subtitle: e.subtitle != null ? Text(e.subtitle!) : null,
            content: SizedBox(
              width: double.infinity,
              child: e.content,
            ),
          );
        }),
      ),
    );
  }
}
