import 'package:ccw/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

import 'package:ccw/members/member_filter.dart';
import 'package:ccw/members/member_manager.dart';
import 'package:ccw/stylesheet.dart';

class IndexScreen extends StatelessWidget with GetItMixin {
  IndexScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // rebuild on notifyListeners:
    final memberList = watchOnly((MemberManager x) => x.memberList);

    final heroStyle = Theme.of(context).textTheme.headline6!.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        );

    const border = BorderSide(color: Color(0xffe6eee9));

    return Scaffold(
      backgroundColor: styles.colorBrand.shade50,
      body: (memberList.isEmpty)
          ? Container()
          : SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      // physics: const ClampingScrollPhysics(),
                      padding: const EdgeInsets.all(10),
                      itemCount: memberList.length,
                      itemBuilder: (context, index) {
                        final member = memberList[index];
                        return InkWell(
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                top: border,
                                bottom: border,
                              ),
                            ),
                            margin: const EdgeInsets.only(bottom: 15),
                            child: ListTile(
                              title: Text(
                                member.index,
                                style: heroStyle,
                              ),
                              subtitle: (member.subIndex != null)
                                  ? Text(member.subIndex!)
                                  : null,
                            ),
                          ),
                          onTap: () {
                            locator<MemberManager>().selectMember(member);
                          },
                        );
                      },
                    ),
                  ),
                  MemberFilter()
                ],
              ),
            ),
    );
  }
}
