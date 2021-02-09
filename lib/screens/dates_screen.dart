import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';

import '../models.dart';
import '../services/member_service.dart';
import '../stylesheet.dart';

class DatesScreen extends StatelessWidget {
  final Function onTap;

  const DatesScreen({@required this.onTap, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final service = context.watch<MemberService>();
    final dates = service.list?.fold<List<MemberDate>>(<MemberDate>[],
            (collected, item) => [...collected, ...item.dates]) ??
        <MemberDate>[];

    return Scaffold(
      backgroundColor: Style.colorBackground,
      body: (service.list?.isEmpty ?? true)
          ? Container()
          : SafeArea(
              child: Padding(
                // padding: const EdgeInsets.only(left: 10),
                padding: const EdgeInsets.all(20),
                child: GroupedListView<MemberDate, int>(
                  elements: dates,
                  groupBy: (element) => element.month,
                  groupSeparatorBuilder: _groupHeader,
                  useStickyGroupSeparators: true, // optional
                  stickyHeaderBackgroundColor: Style.colorBackground,
                  // floatingHeader: false,
                  itemBuilder: (context, item) => InkWell(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 65,
                            child: Text(
                              item.date,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              item.description,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () => notifyTap(item, service),
                  ),
                ),
              ),
            ),
    );
  }

  void notifyTap(MemberDate item, MemberService service) {
    // find the member
    for (final member in service.list) {
      for (final loopItem in member.dates) {
        if (loopItem.isSameAs(item)) {
          onTap(member);
          return;
        }
      }
    }
  }

  Widget _groupHeader(int month) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return Container(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Text("${months[month - 1]}", style: Style.h2),
    );
  }
}
