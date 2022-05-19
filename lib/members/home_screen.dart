import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:provider/provider.dart';

import 'package:ccw/onboarding/tooltips.dart';
import 'models.dart';
import 'member_service.dart';
import '../stylesheet.dart';
import './dates_screen.dart';
import './index_screen.dart';
import './member_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// ignore: prefer_mixin
class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  WidgetsBinding? binding = WidgetsBinding.instance;
  final _innerDrawerKey = GlobalKey<InnerDrawerState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Member? _selectedMember;
  bool _memberListIsOpen = false;
  StreamSubscription<String>? _feedbackSubscription;

  @override
  Widget build(BuildContext context) {
    final service = context.watch<MemberService>();
    final width = MediaQuery.of(context).size.width;
    double sideScreenRatio;
    if (width > 700) {
      sideScreenRatio = 50 / width;
    } else {
      sideScreenRatio = 0.75;
    }

    return Scaffold(
      key: _scaffoldKey,
      body: RefreshIndicator(
        child: InnerDrawer(
          key: _innerDrawerKey,
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
          innerDrawerCallback: _drawerToggled,
          leftChild: IndexScreen(onTap: _selectMember),
          rightChild: DatesScreen(onTap: _selectMember),
          onDragUpdate: (distance, direction) {
            // print("distance: $distance,  direction $direction");
            // InnerDrawerDirection.start - index pane
            // InnerDrawerDirection.end - dates pane

            if (distance < 0.1 || service.hasFoundDates) return;

            if (direction == InnerDrawerDirection.end) {
              service.hasFoundDates = true;
            }
          },
          scaffold: MemberScreen(
            _member(service),
            isTodayMember: _showTodayMember,
          ),
        ),
        onRefresh: () async {
          await service.fetchMembers(isInitial: false);
        },
      ),
      floatingActionButton: _thatButton(service),
    );
  }

  void _selectMember(member) {
    setState(() {
      _selectedMember = member;
      _innerDrawerKey.currentState?.toggle();
    });
  }

  Widget? _thatButton(MemberService service) {
    if (_memberListIsOpen) return null;

    if (!(service.nameIsReady)) return null;

    return FloatingActionButton(
        child: const Icon(Icons.list),
        onPressed: () {
          _innerDrawerKey.currentState?.toggle();
        });
  }

  bool get _showTodayMember => _selectedMember == null;

  Member? _member(MemberService service) {
    if (!_showTodayMember) return _selectedMember;
    final member = Member.forToday(service.list);
    return member;
  }

  Future<void> _drawerToggled(bool wasOpened) async {
    setState(() {
      _memberListIsOpen = wasOpened;
    });
  }

  void onFeedback(String message) {
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
        message,
        style: const TextStyle(fontSize: 18),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    // _scaffoldKey.currentState!.showSnackBar();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;

    setState(() {
      _selectedMember = null;
    });
  }

  @override
  void initState() {
    super.initState();
    binding!.addObserver(this);
    Future.delayed(Duration.zero, () async {
      final service = context.read<MemberService>();
      _feedbackSubscription = service.feedbackStream.listen(onFeedback);
    });
  }

  @override
  void dispose() {
    binding!.removeObserver(this);
    _feedbackSubscription?.cancel();
    super.dispose();
  }
}
