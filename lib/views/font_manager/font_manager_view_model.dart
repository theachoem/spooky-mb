import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spooky/core/base/base_view_model.dart';
import 'package:spooky/gen/fonts.gen.dart';

class FontBeanDisplay {
  final String headline;
  final IconData? iconData;
  FontBeanDisplay(
    this.headline,
    this.iconData,
  );
}

class FontBean extends ISuspensionBean {
  final String family;
  String tag;

  FontBean({
    required this.family,
    required this.tag,
  });

  @override
  String getSuspensionTag() {
    return tag;
  }

  FontBeanDisplay display() {
    String tag = getSuspensionTag();
    switch (tag) {
      case "★":
        return FontBeanDisplay("Recommended", Icons.star);
      case "#":
        return FontBeanDisplay("Others", null);
      default:
        return FontBeanDisplay(tag, null);
    }
  }
}

class FontManagerViewModel extends BaseViewModel {
  late final List<FontBean> fonts;

  final List<String> allFonts = GoogleFonts.asMap().keys.toList();
  final List<String> recommended = [FontFamily.quicksand];

  FontManagerViewModel() {
    fonts = _getBeans();
  }

  List<FontBean> _getBeans() {
    List<FontBean> list = allFonts.map((e) {
      return FontBean(family: e, tag: e.toUpperCase()[0]);
    }).toList();

    if (list.isEmpty) return [];
    for (int i = 0; i < list.length; i++) {
      FontBean font = list[i];
      if (!RegExp("[A-Z]").hasMatch(font.getSuspensionTag())) {
        list[i].tag = "#";
      }
      if (recommended.contains(font.family)) {
        list[i].tag = "★";
      }
    }

    SuspensionUtil.sortListBySuspensionTag(list);
    list = sortRecommended(list);

    SuspensionUtil.setShowSuspensionStatus(list);
    return list;
  }

  String trimFontWeight(FontWeight weight) {
    return weight.toString().replaceFirst("FontWeight.w", "");
  }

  List<FontBean> sortRecommended(List<FontBean>? list) {
    if (list == null || list.isEmpty) return [];
    list.sort((a, b) {
      if (a.getSuspensionTag() == "★") {
        return -1;
      } else {
        if (a.getSuspensionTag() == "@" || b.getSuspensionTag() == "#") {
          return -1;
        } else if (a.getSuspensionTag() == "#" || b.getSuspensionTag() == "@") {
          return 1;
        } else {
          return a.getSuspensionTag().compareTo(b.getSuspensionTag());
        }
      }
    });
    return list;
  }
}
