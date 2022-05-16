import 'package:flutter/material.dart';

final styles = _Styles();

class _Styles {
  // see: https://material.io/resources/color/#!/?view.left=0&view.right=1&primary.color=ED664C&secondary.color=68CFD9&primary.text.color=ffffff
  /// mcg.mbitson.com/#!?primary=%23ed664c&secondary=%2368CFD9
  static const MaterialColor _colorBrand =
      MaterialColor(_brandColor, <int, Color>{
    50: Color(0xFFFDEDEA),
    100: Color(0xFFFAD1C9),
    200: Color(0xFFF6B3A6),
    300: Color(0xFFF29482),
    400: Color(0xFFF07D67),
    500: Color(_brandColor),
    600: Color(0xFFEB5E45),
    700: Color(0xFFE8533C),
    800: Color(0xFFE54933),
    900: Color(0xFFE03824),
  });
  static const int _brandColor = 0xFFED664C;

  MaterialColor get colorBrand => _colorBrand;

  static const MaterialColor _colorSecondary =
      MaterialColor(_secondaryColor, <int, Color>{
    50: Color(0xFFEDF9FA),
    100: Color(0xFFD2F1F4),
    200: Color(0xFFB4E7EC),
    300: Color(0xFF95DDE4),
    400: Color(0xFF7FD6DF),
    500: Color(_secondaryColor),
    600: Color(0xFF60CAD5),
    700: Color(0xFF55C3CF),
    800: Color(0xFF4BBDCA),
    900: Color(0xFF3AB2C0),
  });
  static const int _secondaryColor = 0xFF68CFD9;

  final styleFeedback = const TextStyle(color: Color(0xfff06060));

  final themeLight = ThemeData(
    brightness: Brightness.light,
    primarySwatch: _colorBrand,
    colorScheme: const ColorScheme.light(
      primary: _colorBrand,
      // primaryVariant: _brandColor.shade700,
      secondary: _colorSecondary,
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: _colorSecondary,
      shape: RoundedRectangleBorder(),
      // textTheme: ButtonTextTheme.accent,
    ),
  );

  final h2 = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );
}
