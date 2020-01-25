import 'package:flutter/material.dart';
import './services/cloud_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _password = TextEditingController();
  LoginStatus _status = LoginStatus.Ready;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.only(left: 40, right: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                  "CCW prayer information is not publically available. If you know our password, please enter it here to unlock the app."),
              SizedBox(height: 20, width: 0),
              Text("Password"),
              TextField(
                controller: _password,
                obscureText: true,
                autocorrect: false,
              ),
              SizedBox(height: 20, width: 0),
              RaisedButton(
                onPressed: (_status == LoginStatus.Checking)
                    ? null
                    : () async {
                        await tryLogin();
                      },
                child: Text('Unlock'),
              ),
              SizedBox(height: 20, width: 0),
              _feedbackRow
            ],
          ),
        ),
      ),
    );
  }

  Future tryLogin() async {
    setState(() {
      _status = LoginStatus.Checking;
    });

    try {
      final keys = await cloud.login(_password.text);
      Navigator.pop(context, keys);
    } catch (e) {
      setState(() {
        _status = LoginStatus.Fail;
      });
      print(e);
      return;
    }
  }

  get _feedbackRow {
    switch (_status) {
      case LoginStatus.Fail:
        return Text("Nope. Try again.");
      case LoginStatus.Checking:
        return Text("Let me check that.");
      default:
        return Container();
    }
  }
}

enum LoginStatus { Ready, Checking, Fail }
