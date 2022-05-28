import 'package:ccw/onboarding/onboard_manager.dart';
import 'package:ccw/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

import 'package:ccw/onboarding/login_screen.dart';
import 'package:ccw/members/home_screen.dart';
import 'stylesheet.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await registerServices();
  runApp(CCW());
}

class CCW extends StatelessWidget with GetItMixin {
  CCW({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isSignedIn = watchX((OnboardManager m) => m.isSignedIn);
    return MaterialApp(
      title: 'CCW Prayer',
      theme: styles.themeLight,
      home: Navigator(
        pages: [
          MaterialPage(
            key: const ValueKey('HomePage'),
            child: HomeScreen(),
          ),
          if (!isSignedIn)
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
