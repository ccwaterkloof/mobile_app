import 'package:flutter/material.dart';

// ignore: avoid_classes_with_only_static_members
class Style {
  static const colorBrand = Colors.lime;
  static const colorBackground = const Color(0xfffF9FBE7); // Colors.lime[50];
  static const styleFeedback = const TextStyle(color: Color(0xfff06060));

  static final theme = ThemeData(
    primarySwatch: colorBrand,
    buttonTheme: const ButtonThemeData(
      buttonColor: colorBrand,
      shape: const RoundedRectangleBorder(),
      // textTheme: ButtonTextTheme.accent,
    ),
  );

  static const h2 = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );
}
