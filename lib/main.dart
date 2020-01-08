import 'package:flutter/material.dart';
import 'stylesheet.dart';
import "today_screen.dart";

void main() => runApp(CCW());

class CCW extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: Style.theme,
      home: TodayScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
