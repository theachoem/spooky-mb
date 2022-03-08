import 'package:flutter/material.dart';
import 'package:fuzzy/data/result.dart';
import 'package:fuzzy/fuzzy.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/views/font_manager/local_widgets/font_tile.dart';
import 'package:spooky/widgets/sp_animated_icon.dart';
import 'package:spooky/widgets/sp_icon_button.dart';
import 'package:spooky/widgets/sp_pop_button.dart';

class FontManagerSearchDelegate extends SearchDelegate {
  final List<String> fonts;
  final void Function(String fontFamily) onPressed;
  final Fuzzy<String> fuzzy;

  FontManagerSearchDelegate({
    required this.fonts,
    required this.onPressed,
  }) : fuzzy = Fuzzy(fonts, options: FuzzyOptions(isCaseSensitive: false));

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      SpAnimatedIcons(
        firstChild: SpIconButton(icon: Icon(Icons.clear), onPressed: () => query = ""),
        secondChild: const SizedBox.shrink(),
        showFirst: query.trim().isNotEmpty,
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return const SpPopButton();
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
        return FontTile(
          fontFamily: item,
          onFontUpdated: () async {
            await Future.delayed(ConfigConstant.fadeDuration);
            close(context, _suggestions);
          },
        );
      },
    );
  }

  List<String> suggestions() {
    List<Result<String>> result = fuzzy.search(query.trim());
    // result.sort((a, b) => a.score.compareTo(b.score));
    return result.map((e) => e.item).toList();
  }
}
