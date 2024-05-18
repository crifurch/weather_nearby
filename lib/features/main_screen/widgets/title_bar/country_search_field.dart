import 'dart:async';

import 'package:flutter/material.dart';

class CountrySearchField extends StatefulWidget {
  const CountrySearchField({super.key});

  @override
  State<CountrySearchField> createState() => _CountrySearchFieldState();
}

class _CountrySearchFieldState extends State<CountrySearchField> {
  Timer? _timer;

  @override
  Widget build(BuildContext context) => TextField(
        onChanged: (value) {
          _timer?.cancel();
          _timer = Timer(const Duration(milliseconds: 800), () {

          });
        },
      );

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }
}
