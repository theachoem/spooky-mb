import 'package:flutter/material.dart';

class SpInitialState extends StatefulWidget {
  const SpInitialState({
    super.key,
    required this.child,
    required this.onInitialized,
  });

  final Widget child;
  final void Function() onInitialized;

  @override
  State<SpInitialState> createState() => _SpInitialStateState();
}

class _SpInitialStateState extends State<SpInitialState> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      widget.onInitialized();
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
