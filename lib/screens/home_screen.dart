import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:provider/provider.dart';

import './dates_screen.dart';
import './index_screen.dart';
import './member_screen.dart';
import '../components/tooltips.dart';
import '../models.dart';
import '../services/member_service.dart';
import '../stylesheet.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

// ignore: prefer_mixin
class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  WidgetsBinding binding = WidgetsBinding.instance;
  final _innerDrawerKey = GlobalKey<InnerDrawerState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Member _selectedMember;
  bool _memberListIsOpen = false;
  StreamSubscription<String> _feedbackSubscription;

  @override
  Widget build(BuildContext context) {
    final _service = context.watch<MemberService>();
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
          backgroundDecoration: BoxDecoration(color: Style.colorBackground),
          innerDrawerCallback: _drawerToggled,
          leftChild: IndexScreen(onTap: _selectMember),
          rightChild: DatesScreen(onTap: _selectMember),
          onDragUpdate: (distance, direction) {
            // print("distance: $distance,  direction $direction");
            // InnerDrawerDirection.start - index pane
            // InnerDrawerDirection.end - dates pane

            if (distance < 0.1 || _service.hasFoundDates) return;

            if (direction == InnerDrawerDirection.end) {
              _service.hasFoundDates = true;
            }
          },
          scaffold: MemberScreen(
            _member(_service),
            isTodayMember: _showTodayMember,
          ),
        ),
        onRefresh: () async {
          await _service.fetchMembers(isInitial: false);
        },
      ),
      floatingActionButton: _thatButton(_service),
    );
  }

  void _selectMember(member) {
    setState(() {
      _selectedMember = member;
      _innerDrawerKey?.currentState?.toggle();
    });
  }

  Widget _thatButton(MemberService service) {
    if (_memberListIsOpen) return null;

    if (!(service?.nameIsReady ?? false)) return null;

    return FloatingActionButton(
        child: new Icon(Icons.list),
        onPressed: () {
          _innerDrawerKey?.currentState?.toggle();
        });
  }

  bool get _showTodayMember => _selectedMember == null;

  Member _member(MemberService service) {
    if (!_showTodayMember) return _selectedMember;
    final member = Member.forToday(service?.list ?? []);
    return member;
  }

  Future<void> _drawerToggled(bool wasOpened) async {
    setState(() {
      _memberListIsOpen = wasOpened;
    });
  }

  void onFeedback(String message) {
    if (message == "tooltip1") {
      final overlay = Overlay.of(context);
      final tooltipOne = OverlayEntry(
        builder: (context) {
          return ToolTipDates();
        },
      );
      overlay.insert(tooltipOne);
      Future.delayed(Duration(seconds: 5), () {
        tooltipOne.remove();
      });
      return;
    }
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        message,
        style: TextStyle(fontSize: 18),
      ),
    ));
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
    binding.addObserver(this);
    Future.delayed(Duration.zero, () async {
      final service = context.read<MemberService>();
      _feedbackSubscription = service.feedbackStream.listen(onFeedback);
    });
  }

  @override
  void dispose() {
    binding.removeObserver(this);
    _feedbackSubscription?.cancel();
    super.dispose();
  }
}
