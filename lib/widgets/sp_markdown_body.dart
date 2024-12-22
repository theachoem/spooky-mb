import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class SpMarkdownBody extends StatelessWidget {
  const SpMarkdownBody({
    super.key,
    required this.body,
  });

  final String body;

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: body,
      onTapLink: (url, _, __) {},
      styleSheet: MarkdownStyleSheet(
        blockquoteDecoration: BoxDecoration(
          color: Colors.transparent,
          border: Border(
            left: BorderSide(color: Theme.of(context).dividerColor),
          ),
        ),
        blockquotePadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
        codeblockDecoration: BoxDecoration(border: Border.all(color: Theme.of(context).dividerColor)),
        listBulletPadding: const EdgeInsets.all(2),
        listIndent: 16,
        blockSpacing: 0.0,
      ),
      checkboxBuilder: (checked) {
        return Transform.translate(
          offset: const Offset(-3.5, 2.5),
          child: Icon(
            checked ? Icons.check_box : Icons.check_box_outline_blank,
            size: 16.0,
          ),
        );
      },
      softLineBreak: true,
    );
  }
}
