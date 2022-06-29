import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/helpers/date_format_helper.dart';
import 'package:spooky/widgets/sp_pop_up_menu_button.dart';

class UserImageProfile extends StatelessWidget {
  late final String? profileUrl;
  final User currentUser;
  final ValueNotifier<double> scrollOffsetNotifier;

  UserImageProfile({
    Key? key,
    required this.scrollOffsetNotifier,
    required this.currentUser,
  }) : super(key: key) {
    profileUrl = maximizeImage(currentUser.photoURL);
  }

  String? maximizeImage(String? imageUrl) {
    if (imageUrl == null) return null;
    String lowQuality = "s96-c";
    String highQuality = "s0";
    return imageUrl.replaceAll(lowQuality, highQuality);
  }

  final double avatarSize = 72;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      final width = constraint.maxWidth;
      return ValueListenableBuilder(
        valueListenable: scrollOffsetNotifier,
        builder: (context, double offset, child) {
          final bool isCollapse = offset < 200;
          final avatarSize = isCollapse ? width : this.avatarSize;
          final padding = isCollapse ? EdgeInsets.zero : const EdgeInsets.all(16);
          return AnimatedContainer(
            duration: ConfigConstant.duration,
            curve: Curves.easeOutQuart,
            width: width,
            height: width,
            padding: padding,
            alignment: Alignment.bottomLeft,
            color: M3Color.of(context).background,
            child: AnimatedOpacity(
              duration: ConfigConstant.fadeDuration,
              curve: Curves.decelerate,
              opacity: offset < 350 ? 1 : 0,
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  buildPhoto(avatarSize, isCollapse),
                  buildProfileInfoTile(isCollapse, context),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  Widget buildProfileInfoTile(bool isCollapse, BuildContext context) {
    return AnimatedContainer(
      duration: ConfigConstant.duration,
      width: double.infinity,
      curve: Curves.easeOutQuart,
      height: 72,
      margin: EdgeInsets.only(left: isCollapse ? 0 : avatarSize + 16),
      decoration: BoxDecoration(
        borderRadius: isCollapse ? BorderRadius.zero : ConfigConstant.circlarRadius2,
        color: M3Color.of(context).primaryContainer.withOpacity(isCollapse ? 1 : 1),
      ),
      child: SpPopupMenuButton(
        dxGetter: (dx) => MediaQuery.of(context).size.width,
        dyGetter: (dy) => dy + kToolbarHeight + 24.0,
        items: (context) {
          String id = currentUser.uid;
          return [
            SpPopMenuItem(
              title: "Identity",
              subtitle: id,
              onPressed: () {
                Clipboard.setData(ClipboardData(text: id));
              },
            ),
            if (currentUser.metadata.creationTime != null)
              SpPopMenuItem(
                title: "Created at",
                subtitle: DateFormatHelper.dateTimeFormat().format(currentUser.metadata.creationTime!),
              ),
            if (currentUser.metadata.lastSignInTime != null)
              SpPopMenuItem(
                title: "Last sign in",
                subtitle: DateFormatHelper.dateTimeFormat().format(currentUser.metadata.lastSignInTime!),
              ),
          ];
        },
        builder: (callback) {
          return ListTile(
            onTap: callback,
            title: Text(
              currentUser.displayName ?? "",
              style: TextStyle(color: M3Color.of(context).primary),
            ),
            subtitle: Text(
              currentUser.email ?? currentUser.uid,
              style: TextStyle(color: M3Color.of(context).primary),
            ),
            trailing: Icon(
              Icons.info,
              color: M3Color.of(context).primary,
            ),
          );
        },
      ),
    );
  }

  Widget buildPhoto(double avatarSize, bool isCollapse) {
    bool hasPhoto = profileUrl != null;
    return AnimatedContainer(
      duration: ConfigConstant.duration,
      curve: Curves.easeOutQuart,
      width: avatarSize,
      height: avatarSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          isCollapse ? 0 : avatarSize,
        ),
        image: hasPhoto
            ? DecorationImage(
                image: CachedNetworkImageProvider(profileUrl!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: !hasPhoto
          ? const Icon(
              Icons.person,
              size: ConfigConstant.iconSize5,
            )
          : null,
    );
  }
}
