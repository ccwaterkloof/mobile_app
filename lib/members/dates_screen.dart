import 'package:ccw/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:grouped_list/grouped_list.dart';

import 'package:ccw/members/member_manager.dart';
import 'package:ccw/models/member.dart';
import 'package:ccw/stylesheet.dart';
import 'package:ccw/report/report_screen.dart';

class DatesScreen extends StatelessWidget with GetItMixin {
  DatesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dates = watchOnly((MemberManager m) => m.allDates);

    return Scaffold(
      backgroundColor: styles.colorBrand.shade50,
      body: (dates.isEmpty)
          ? Container()
          : SafeArea(
              child: Padding(
                // padding: const EdgeInsets.only(left: 10),
                padding: const EdgeInsets.all(20),
                child: GroupedListView<MemberDate, int?>(
                  elements: dates,
                  groupBy: (element) => element.month,
                  groupSeparatorBuilder: (month) =>
                      _groupHeader(context, month),
                  useStickyGroupSeparators: true, // optional
                  stickyHeaderBackgroundColor: styles.colorBrand.shade50,
                  // floatingHeader: false,
                  itemBuilder: (context, item) => InkWell(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 65,
                            child: Text(
                              item.date,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(item.description!),
                          ),
                        ],
                      ),
                    ),
                    onTap: () =>
                        locator<MemberManager>().selectMemberFromDate(item),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _groupHeader(BuildContext context, int? month) {
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
      child: ReportGesture(
        child: Text(months[month! - 1], style: styles.h2),
      ),
    );
  }
}
