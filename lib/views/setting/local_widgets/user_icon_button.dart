import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/widgets/sp_icon_button.dart';
import 'package:spooky/utils/constants/config_constant.dart';

class UserIconButton extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  UserIconButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? photoURL = FirebaseAuth.instance.currentUser?.photoURL;
    bool isSignIn = FirebaseAuth.instance.currentUser != null;
    return SpIconButton(
      padding: const EdgeInsets.all(8),
      icon: AnimatedContainer(
        padding: const EdgeInsets.all(2),
        duration: ConfigConstant.fadeDuration,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: photoURL == null
              ? null
              : Border.all(
                  width: 2.0,
                  color: M3Color.of(context).onSurface,
                ),
        ),
        child: CircleAvatar(
          backgroundColor: M3Color.of(context).primary,
          backgroundImage: photoURL != null ? CachedNetworkImageProvider(photoURL) : null,
          child: photoURL == null
              ? Icon(
                  Icons.person,
                  color: M3Color.of(context).onPrimary,
                )
              : null,
        ),
      ),
      onPressed: () {
        if (isSignIn) {
          Navigator.of(context).pushNamed(SpRouter.user.path);
        } else {
          Navigator.of(context).pushNamed(SpRouter.signUp.path);
        }
      },
    );
  }
}
