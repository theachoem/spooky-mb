import 'package:fuzzy/data/result.dart';
import 'package:fuzzy/fuzzy.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:spooky/providers/theme_provider.dart';
import 'package:spooky/widgets/sp_fade_in.dart';
import 'package:spooky/widgets/sp_pop_up_menu_button.dart';
import 'package:spooky/widgets/sticky_header/sticky_header.dart';

import 'fonts_view_model.dart';

part 'fonts_adaptive.dart';

class FontsView extends StatelessWidget {
  const FontsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<FontsViewModel>(
      create: (context) => FontsViewModel(context: context),
      builder: (context, viewModel, child) {
        return _FontsAdaptive(viewModel);
      },
    );
  }
}
