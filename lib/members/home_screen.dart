import 'dart:async';

import 'package:ccw/services/store_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

import 'package:ccw/members/member_manager.dart';
import 'package:ccw/services/service_locator.dart';
import 'package:ccw/onboarding/tooltips.dart';
import 'package:ccw/stylesheet.dart';
import 'package:ccw/members/dates_screen.dart';
import 'package:ccw/members/index_screen.dart';
import 'package:ccw/members/member_screen.dart';

class HomeScreen extends StatefulWidget with GetItStatefulWidgetMixin {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// ignore: prefer_mixin
class _HomeScreenState extends State<HomeScreen>
    with GetItStateMixin, WidgetsBindingObserver {
  WidgetsBinding? binding = WidgetsBinding.instance;

  @override
  Widget build(BuildContext context) {
    final manager = watchOnly((MemberManager m) => m);
    final hideFab = watchOnly((MemberManager m) => m.hideFab);

    registerHandler((MemberManager m) => m.feedback, _handleFeedback);

    final width = MediaQuery.of(context).size.width;
    double sideScreenRatio;
    if (width > 700) {
      sideScreenRatio = 50 / width;
    } else {
      sideScreenRatio = 0.75;
    }

    return Scaffold(
      key: GlobalKey<ScaffoldState>(),
      body: RefreshIndicator(
        onRefresh: manager.refreshList,
        child: InnerDrawer(
          key: locator<MemberManager>().innerDrawerKey,
          colorTransitionScaffold: Colors.white.withOpacity(0),
          onTapClose: true, // default false
          // swipe: true, // default true
          swipeChild: true,
          offset: IDOffset.only(
            left: sideScreenRatio,
            right: sideScreenRatio,
          ),
          // leftAnimationType: InnerDrawerAnimation.static, // default static
          rightAnimationType: InnerDrawerAnimation.quadratic,
          backgroundDecoration: BoxDecoration(color: styles.colorBrand.shade50),
          innerDrawerCallback: manager.drawerToggled,
          leftChild: IndexScreen(),
          rightChild: DatesScreen(),
          onDragUpdate: (distance, direction) {
            // print("distance: $distance,  direction $direction");
            // InnerDrawerDirection.start - index pane
            // InnerDrawerDirection.end - dates pane
            final service = locator<StoreService>();

            if (distance < 0.1 || service.hasFoundDates) return;

            if (direction == InnerDrawerDirection.end) {
              service.setHasFoundDates(true);
            }
          },
          scaffold: MemberScreen(),
        ),
      ),
      floatingActionButton: hideFab
          ? null
          : FloatingActionButton(
              onPressed: manager.toggleDrawer,
              child: const Icon(Icons.list),
            ),
    );
  }

  void _handleFeedback(
      BuildContext context, String? message, void Function() cancel) {
    if (message?.isEmpty ?? true) return;

    if (message == "tooltip1") {
      final overlay = Overlay.of(context)!;
      final tooltipOne = OverlayEntry(
        builder: (context) {
          return const ToolTipDates();
        },
      );
      overlay.insert(tooltipOne);
      Future.delayed(const Duration(seconds: 5), () {
        tooltipOne.remove();
      });
      return;
    }
    final snackBar = SnackBar(
      content: Text(
        message ?? "",
        style: const TextStyle(fontSize: 18),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;

    locator<MemberManager>().startOver();
  }

  @override
  void initState() {
    super.initState();
    binding!.addObserver(this);
  }

  @override
  void dispose() {
    binding!.removeObserver(this);
    super.dispose();
  }
}
