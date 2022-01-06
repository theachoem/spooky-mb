import 'package:flutter/material.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/ui/widgets/sp_chip.dart';
import 'package:spooky/ui/widgets/sp_tap_effect.dart';
import 'package:spooky/utils/constants/config_constant.dart';

class StoryList extends StatelessWidget {
  const StoryList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 10,
      padding: ConfigConstant.layoutPadding,
      separatorBuilder: (context, index) {
        return Divider(
          indent: 16 + 20 + 16 + 4,
          color: M3Color.of(context)?.secondary.m3Opacity.opacity016,
          height: 0,
        );
      },
      itemBuilder: (context, index) {
        return SpTapEffect(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: ConfigConstant.margin2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildMonogram(),
                ConfigConstant.sizedBoxW2,
                buildContent(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildContent(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'First day as a CS student',
                style: M3TextTheme.of(context)?.titleMedium,
              ),
              ConfigConstant.sizedBoxH0,
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc eget et turpis sodales ipsum diam viverra. Imperdiet mauris mass...',
                style: M3TextTheme.of(context)?.bodyMedium,
              ),
              ConfigConstant.sizedBoxH0,
              const SpChip(
                labelText: '3 Images',
                avatar: CircleAvatar(
                  backgroundImage: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                ),
              )
            ],
          ),
          buildTime(context)
        ],
      ),
    );
  }

  Widget buildTime(BuildContext context) {
    return Positioned(
      right: 0,
      child: Row(
        children: [
          Icon(
            Icons.favorite,
            size: ConfigConstant.iconSize1,
            color: M3Color.of(context)?.error,
          ),
          ConfigConstant.sizedBoxW0,
          Text(
            '9:32pm',
            style: M3TextTheme.of(context)?.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget buildMonogram() {
    return Column(
      children: const [
        ConfigConstant.sizedBoxH0,
        Text("Tue"),
        ConfigConstant.sizedBoxH0,
        CircleAvatar(
          radius: 20,
          child: Text('14'),
        ),
      ],
    );
  }
}
