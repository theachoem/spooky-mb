import 'package:flutter/material.dart';
import 'package:spooky/widgets/sp_pop_button.dart';

class BillDetailScreen extends StatefulWidget {
  const BillDetailScreen({super.key});

  @override
  State<BillDetailScreen> createState() => _BillDetailScreenState();
}

class _BillDetailScreenState extends State<BillDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SpPopButton(),
        title: Text(
          "Add billing",
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
    );
  }
}
