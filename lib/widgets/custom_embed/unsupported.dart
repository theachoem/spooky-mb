import 'package:flutter/material.dart';

class QuillUnsupportedRenderer extends StatelessWidget {
  const QuillUnsupportedRenderer({
    super.key,
    this.message,
    this.buttonLabel,
    this.onPressed,
  });

  final String? message;
  final String? buttonLabel;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: buttonLabel == null ? onPressed : null,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 16.0),
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: ColorScheme.of(context).tertiaryContainer,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error),
            const SizedBox(height: 16.0),
            SelectableText(
              message ?? 'Unsupported embed type',
              textAlign: TextAlign.center,
            ),
            if (buttonLabel != null) ...[
              const SizedBox(height: 8.0),
              OutlinedButton(
                onPressed: onPressed,
                child: Text(buttonLabel!),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
