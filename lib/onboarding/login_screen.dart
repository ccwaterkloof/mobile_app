import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

import 'package:ccw/onboarding/onboard_manager.dart';
import 'package:ccw/services/service_locator.dart';

class LoginScreen extends StatelessWidget with GetItMixin {
  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final status = watchX((OnboardManager m) => m.loginStatus);

    return Material(
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(left: 40, right: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 100),
              const Text(
                "Let's get you in",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text("CCW prayer information is not publically available."
                  " If you know our password, "
                  "please enter it here to unlock the app."),
              const SizedBox(height: 20),
              TextField(
                controller: locator<OnboardManager>().password,
                obscureText: true,
                autocorrect: false,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: (status == LoginStatus.checking)
                    ? null
                    : locator<OnboardManager>().tryLogin,
                child: const Text('Unlock'),
              ),
              const SizedBox(height: 20),
              _feedbackRow
            ],
          ),
        ),
      ),
    );
  }

  Widget get _feedbackRow {
    final status = locator<OnboardManager>().loginStatus.value;
    const styleFeedback = TextStyle(color: Color(0xfff06060));

    switch (status) {
      case LoginStatus.fail:
        return const Text(
          "Nope. Try again.",
          style: styleFeedback,
        );
      case LoginStatus.technicalError:
        return const Text(
          "Erm... we had some difficulty verifying that.\nPlease try again.",
          style: styleFeedback,
        );
      case LoginStatus.checking:
        return const Text("Let me check that.");
      default:
        return Container();
    }
  }
}
