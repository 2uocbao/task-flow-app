import 'package:flutter/material.dart';

class CustomButtonStyle {
  static Color getButtonColor(BuildContext context, bool isSelected) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isSelected) {
      return isDark ? Colors.blueGrey : Colors.grey;
    } else {
      return isDark ? Colors.grey[800]! : Colors.grey[300]!;
    }
  }
}
