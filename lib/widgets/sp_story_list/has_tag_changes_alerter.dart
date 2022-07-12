import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import 'package:spooky/providers/has_tags_changes_provider.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/widgets/sp_cross_fade.dart';

class HasTagChangesAlerter extends StatelessWidget {
  const HasTagChangesAlerter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HasTagsChangesProvider>(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Material(
          elevation: 1,
          color: M3Color.of(context).tertiaryContainer,
          borderRadius: ConfigConstant.circlarRadius1,
          borderOnForeground: true,
          child: InkWell(
            onTap: () => Phoenix.rebirth(context),
            child: Container(
              padding: const EdgeInsets.all(0.0),
              width: double.infinity,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "Tags changed! Tap to refresh",
                  style: Theme.of(context).textTheme.overline?.copyWith(color: M3Color.of(context).tertiary),
                  children: [
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Icon(
                        Icons.arrow_right,
                        color: M3Color.of(context).tertiary,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      builder: (context, provider, child) {
        return SpCrossFade(
          firstChild: child!,
          secondChild: const SizedBox(width: double.infinity),
          showFirst: provider.hasChanges,
        );
      },
    );
  }
}
