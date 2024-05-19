import 'dart:async';

import 'package:flutter/material.dart';

///don't use it on large components
class EverySecondBuilder extends StatefulWidget {
  final Widget Function() build;

  const EverySecondBuilder({
    super.key,
    required this.build,
  });

  @override
  State<EverySecondBuilder> createState() => _EverySecondBuilderState();
}

class _EverySecondBuilderState extends State<EverySecondBuilder> {
  late Timer timer;

  @override
  void initState() {
    super.initState();
    _updateTimer();
  }

  @override
  Widget build(BuildContext context) => widget.build();

  void _updateTimer() {
    timer = Timer(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {});
      }
      _updateTimer();
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
