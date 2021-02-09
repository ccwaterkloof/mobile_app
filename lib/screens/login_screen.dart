import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/member_service.dart';
import '../stylesheet.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _password = TextEditingController();
  MemberService _service;
  LoginStatus _status = LoginStatus.ready;

  @override
  Widget build(BuildContext context) {
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
                controller: _password,
                obscureText: true,
                autocorrect: false,
              ),
              const SizedBox(height: 20),
              RaisedButton(
                onPressed: (_status == LoginStatus.checking) ? null : _tryLogin,
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

  Future _tryLogin() async {
    setState(() {
      _status = LoginStatus.checking;
    });

    try {
      await _service.login(_password.text);
      // Navigator.pop  // nav 1.0
    } on FourOhOneError {
      setState(() {
        _status = LoginStatus.fail;
      });
    } catch (e) {
      setState(() {
        _status = LoginStatus.technicalError;
      });
    }
  }

  Widget get _feedbackRow {
    switch (_status) {
      case LoginStatus.fail:
        return const Text("Nope. Try again.", style: Style.styleFeedback);
      case LoginStatus.technicalError:
        return const Text(
          "Erm... we had some difficulty verifying that.\nPlease try again.",
          style: Style.styleFeedback,
        );
      case LoginStatus.checking:
        return const Text("Let me check that.");
      default:
        return Container();
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _service = context.read<MemberService>();
    });
  }
}

enum LoginStatus { ready, checking, fail, technicalError }
