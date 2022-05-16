import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';

import '../models.dart';
import '../services/member_service.dart';
import '../stylesheet.dart';
import './report_screen.dart';

class DatesScreen extends StatefulWidget {
  final Function onTap;

  const DatesScreen({required this.onTap, Key? key}) : super(key: key);

  @override
  State<DatesScreen> createState() => _DatesScreenState();
}

class _DatesScreenState extends State<DatesScreen> with TestHelper {
  @override
  Widget build(BuildContext context) {
    final service = context.watch<MemberService>();
    final dates = service.list.fold<List<MemberDate>>(
        <MemberDate>[], (collected, item) => [...collected, ...item.dates!]);

    return Scaffold(
      backgroundColor: styles.colorBrand.shade50,
      body: (service.list.isEmpty)
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
      for (final loopItem in member.dates!) {
        if (loopItem.isSameAs(item)) {
          widget.onTap(member);
          return;
        }
      }
    }
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
      child: GestureDetector(
        onTap: () => detectSecretGesture(context),
        child: Text(months[month! - 1], style: styles.h2),
      ),
    );
  }
}
