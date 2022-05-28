import 'package:ccw/members/member_manager.dart';
import 'package:ccw/models/errors.dart';
import 'package:ccw/services/login_service.dart';
import 'package:ccw/services/service_locator.dart';
import 'package:ccw/services/store_service.dart';
import 'package:flutter/material.dart';

class OnboardManager {
  final StoreService _store;
  final isSignedIn = ValueNotifier<bool>(false);
  final hasFoundDates = ValueNotifier<bool>(false);
  final loginStatus = ValueNotifier<LoginStatus>(LoginStatus.ready);
  final password = TextEditingController();

  OnboardManager(this._store) {
    isSignedIn.value = _store.hasKeys;
    hasFoundDates.value = _store.hasFoundDates;
  }

  Future<void> tryLogin() async {
    loginStatus.value = LoginStatus.checking;

    final service = locator<LoginService>();
    try {
      final credentials = await service.login(password.text);
      await _store.setCredentials(credentials);
      isSignedIn.value = true;
      loginStatus.value = LoginStatus.ready;
      await locator<MemberManager>().refreshList(isInitial: true);
    } on FourOhOneError {
      loginStatus.value = LoginStatus.fail;
    } catch (e) {
      loginStatus.value = LoginStatus.technicalError;
    }
  }
}

enum LoginStatus { ready, checking, fail, technicalError }
