import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import "./screens/home_screen.dart";
import "./screens/login_screen.dart";
import './services/member_service.dart';
import 'stylesheet.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final service = await MemberService.create();
  runApp(
    ChangeNotifierProvider<MemberService>(
      create: (_) => service,
      lazy: false,
      child: CCW(),
    ),
  );
}

class CCW extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final service = context.watch<MemberService>();
    return MaterialApp(
      title: 'CCW Prayer',
      theme: Style.theme,
      home: Navigator(
        pages: [
          MaterialPage(
            key: const ValueKey('HomePage'),
            child: HomeScreen(),
          ),
          if (!service.hasKeys)
            MaterialPage(
              key: const ValueKey('LoginPage'),
              child: LoginScreen(),
            )
        ],
        onPopPage: (route, result) => route.didPop(result),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
