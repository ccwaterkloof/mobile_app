import 'package:ccw/models/errors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';

import 'package:ccw/models/member.dart';
import 'package:ccw/services/service_locator.dart';
import 'package:ccw/services/trello_service.dart';

class MemberManager extends ChangeNotifier {
  MemberManager() {
    refreshList(isInitial: true);
  }

  final feedback = ValueNotifier<String?>(null);

  List<Member> _allMembers = [];

  List<Member> get memberList {
    if (!isFiltered) return _allMembers;

    final shortList = _searchIndex[_searchFilter];
    return _allMembers
        .where((member) => shortList!.contains(member.id))
        .toList();
  }

  Future<void> refreshList({bool isInitial = false}) async {
    try {
      _allMembers = await locator<TrelloService>().fetchMembers();
      _allDates = _allMembers.fold<List<MemberDate>>(
          <MemberDate>[], (collected, item) => [...collected, ...item.dates!]);
      await _buildSearchIndex();

      if (!isInitial) {
        notifyListeners();
        return;
      }

      // animation trigger
      Future.delayed(const Duration(seconds: 1), () {
        _nameIsReady = true;
        notifyListeners();
      });
    } on FeedbackException catch (e) {
      if (isInitial) feedback.value = e.feedback;
    } catch (_) {
      // swallow
    }
  }

  Future<void> startOver() async {
    feedback.value = null;
    selectedMember = null;
    memberListIsOpen = false;
    await refreshList(isInitial: true);
  }

  List<Member> get reportList =>
      _allMembers.where((member) => member.isBroken).toList();

  // ------------------------------------
  // Member screen
  // ------------------------------------

  bool _nameIsReady = false;
  bool get nameIsReady => _nameIsReady;

  bool get showTodayMember => selectedMember == null;

  Member? get memberToShow {
    if (selectedMember != null) return selectedMember;

    final member = Member.forToday(_allMembers);
    return member;
  }

  // ------------------------------------
  // Dates
  // ------------------------------------

  List<MemberDate> _allDates = [];

  List<MemberDate> get allDates => _allDates;

  void selectMemberFromDate(MemberDate date) {
    for (final member in _allMembers) {
      for (final loopItem in member.dates!) {
        if (loopItem.isSameAs(date)) {
          selectMember(member);
          return;
        }
      }
    }
  }

  // ------------------------------------
  // Searching
  // ------------------------------------

  late Map<String, List<String?>> _searchIndex;
  List<String> get _searchKeys {
    final keys = _searchIndex.keys.toList();
    keys.add("");
    keys.sort();
    return keys;
  }

  String _searchFilter = "";
  String get searchFilter => _searchFilter;

  bool get isFiltered => _searchFilter != "";

  int _filterGuage = 0;

  void setGuage(double value) {
    final newValue = value.round();
    if (newValue == _filterGuage) return;
    _filterGuage = newValue;
    notifyListeners();
  }

  void setFilter(double value) {
    _filterGuage = value.round();
    _searchFilter = filterLabel;
    notifyListeners();
  }

  void clearFilter() {
    _filterGuage = 0;
    _searchFilter = "";
    notifyListeners();
  }

  int get searchSliderMax => (_searchKeys.isEmpty) ? 0 : _searchKeys.length - 1;
  double get filterGuage => _filterGuage.toDouble();

  String get filterLabel {
    if (_filterGuage == 0 ||
        _filterGuage < 0 ||
        _filterGuage > _searchKeys.length - 1) return "";

    return _searchKeys[_filterGuage];
  }

  Future<void> _buildSearchIndex() async {
    _searchIndex = {};
    _filterGuage = 0;
    _searchFilter = "";

    for (final member in _allMembers) {
      for (final c in member.capitals) {
        _searchIndex.update(c, (ids) {
          if (ids.contains(member.id)) return ids;
          ids.add(member.id);
          return ids;
        }, ifAbsent: () => [member.id]);
      }
    }
  }

  // ------------------------------------
  // Navigation
  // ------------------------------------

  Member? selectedMember;
  final innerDrawerKey = GlobalKey<InnerDrawerState>();
  bool memberListIsOpen = false;

  bool get hideFab => memberListIsOpen || !_nameIsReady;

  void toggleDrawer() {
    innerDrawerKey.currentState?.toggle();
  }

  Future<void> drawerToggled(bool wasOpened) async {
    memberListIsOpen = wasOpened;
    notifyListeners();
  }

  void selectMember(Member member) {
    selectedMember = member;
    notifyListeners();
    innerDrawerKey.currentState?.toggle();
  }
}
