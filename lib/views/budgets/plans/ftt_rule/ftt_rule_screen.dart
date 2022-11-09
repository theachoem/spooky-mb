import 'package:flutter/material.dart';
import 'package:spooky/widgets/sp_pop_button.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class FttRuleScreen extends StatefulWidget {
  const FttRuleScreen({super.key});

  @override
  State<FttRuleScreen> createState() => _FttRuleScreenState();
}

class _FttRuleScreenState extends State<FttRuleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(
        leading: const SpPopButton(),
        title: const Text("50/30/20"),
      ),
    );
  }
}
