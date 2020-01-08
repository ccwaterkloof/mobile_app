import 'package:flutter/material.dart';

class Style {
  static final theme = ThemeData(
    primarySwatch: Colors.lime,
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.lime,
      shape: RoundedRectangleBorder(),
      // textTheme: ButtonTextTheme.accent,
    ),
  );

  static final h2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );
}
