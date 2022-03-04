import 'package:flutter/material.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/views/font_manager/local_widgets/preview_trailing.dart';
import 'package:spooky/widgets/sp_pop_button.dart';

class FontManagerSearchDelegate extends SearchDelegate {
  final List<String> fonts;
  final void Function(String fontFamily) onPressed;

  FontManagerSearchDelegate({
    required this.fonts,
    required this.onPressed,
  });

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return SpPopButton();
  }

  @override
  void showResults(BuildContext context) {}

  @override
  Widget buildResults(BuildContext context) {
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> _suggestions = suggestions();
    return ListView.builder(
      itemCount: _suggestions.length,
      itemBuilder: (context, index) {
        String item = _suggestions[index];
        return ListTile(
          title: Text(item),
          trailing: PreviewTrailing(fontFamily: item, context: context),
          onTap: () async {
            onPressed(item);
            await Future.delayed(ConfigConstant.fadeDuration);
            close(context, _suggestions);
          },
        );
      },
    );
  }

  List<String> suggestions() {
    return fonts.where((element) {
      return element.toLowerCase().contains(query.trim().toLowerCase());
    }).toList();
  }
}
