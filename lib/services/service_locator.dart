import 'package:ccw/members/member_manager.dart';
import 'package:ccw/onboarding/onboard_manager.dart';
import 'package:ccw/services/trello_service.dart';
import 'package:ccw/services/login_service.dart';
import 'package:ccw/services/store_service.dart';

import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

Future<void> registerServices() async {
  final store = await StoreService.create();
  locator.registerSingleton<StoreService>(store);
  locator.registerLazySingleton<LoginService>(() => LoginService());
  locator.registerLazySingleton<TrelloService>(() => TrelloService(store));

  // managers
  locator.registerSingleton<OnboardManager>(OnboardManager(store));
  locator.registerSingleton<MemberManager>(MemberManager());
}
