import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:ccw/onboarding/login_screen.dart';
import 'package:ccw/members/home_screen.dart';
import 'members/member_service.dart';
import 'stylesheet.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final service = await MemberService.create();
  runApp(
    ChangeNotifierProvider<MemberService>(
      create: (_) => service,
      lazy: false,
      child: const CCW(),
    ),
  );
}

class CCW extends StatelessWidget {
  const CCW({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final service = context.watch<MemberService>();
    return MaterialApp(
      title: 'CCW Prayer',
      theme: styles.themeLight,
      home: Navigator(
        pages: [
          const MaterialPage(
            key: ValueKey('HomePage'),
            child: HomeScreen(),
          ),
          if (!service.hasKeys)
            const MaterialPage(
              key: ValueKey('LoginPage'),
              child: LoginScreen(),
            )
        ],
        onPopPage: (route, result) => route.didPop(result),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
