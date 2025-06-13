import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  void pushMaterialPageRoute(Widget screen) {
    Navigator.push(
      this,
      MaterialPageRoute<void>(
        builder: (context) => screen,
      ),
    );
  }
}
