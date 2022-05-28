import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

import 'package:ccw/stylesheet.dart';
import 'package:ccw/services/service_locator.dart';
import 'package:ccw/members/member_manager.dart';

class MemberFilter extends StatelessWidget with GetItMixin {
  MemberFilter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final manager = locator<MemberManager>();
    final isFiltered = watchOnly((MemberManager m) => m.isFiltered);
    final filterGuage = watchOnly((MemberManager m) => m.filterGuage);

    if (isFiltered) return _notice;

    return Row(
      children: [
        Expanded(
          child: SliderTheme(
            data: const SliderThemeData(
              // valueIndicatorColor: Colors.white,
              valueIndicatorTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            child: Slider(
              max: manager.searchSliderMax.toDouble(),
              value: filterGuage,
              label: manager.filterLabel,
              onChanged: manager.setGuage,
              onChangeEnd: manager.setFilter,
              divisions: 26,
            ),
          ),
        ),
      ],
    );
  }

  Widget get _notice => Container(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        color: styles.colorBrand,
        child: Row(
          children: [
            Expanded(
              child: Text(
                'All names with "${locator<MemberManager>().searchFilter}"',
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              color: Colors.white,
              onPressed: locator<MemberManager>().clearFilter,
            ),
          ],
        ),
      );
}
