import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:ccw/members/member_manager.dart';
import 'package:ccw/services/service_locator.dart';
import 'package:ccw/stylesheet.dart';

class MemberScreen extends StatelessWidget with GetItMixin {
  MemberScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final member = watchOnly((MemberManager m) => m.memberToShow);
    final nameIsReady = watchOnly((MemberManager m) => m.nameIsReady);
    final screen = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(_title!),
      ),
      body: ListView(
        physics: const ClampingScrollPhysics(),
        children: [
          Stack(
            children: [
              Column(
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 1.33,
                    child: _image,
                  ),
                  // enough space for two lines of title styled text
                  Container(height: 60),
                ],
              ),
              SizedBox(
                width: screen.width,
                height: 60 + screen.width * 0.75,
                child: AnimatedAlign(
                  curve: Curves.easeInQuad,
                  duration: const Duration(milliseconds: 500),
                  alignment:
                      nameIsReady ? Alignment.bottomLeft : Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Text(
                      nameIsReady
                          ? "${member?.name ?? ''}\n "
                          : "Today we are praying for ...",
                      style: styles.h2,
                      maxLines: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
          _description,
          _dates,
        ],
      ),
    );
  }

  String? get _title {
    final manager = locator<MemberManager>();
    final member = manager.memberToShow;

    if (member == null) return "";

    final today = DateTime.now();
    if (manager.showTodayMember) {
      return formatDate(today, [DD, ', ', d, ' ', MM]);
    }

    return member.title;
  }

  Widget get _image {
    final member = locator<MemberManager>().memberToShow;

    if (member?.imageUrl == null) return Container();

    return CachedNetworkImage(
      imageUrl: member!.imageUrl!,
      fadeInDuration: const Duration(milliseconds: 1500),
    );
  }

  Widget get _description {
    final manager = locator<MemberManager>();
    final member = locator<MemberManager>().memberToShow;

    if (!manager.nameIsReady) return Container();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      child: Text(member?.description ?? ""),
    );
  }

  Widget get _dates {
    final manager = locator<MemberManager>();
    final member = locator<MemberManager>().memberToShow;

    if (manager.showTodayMember) return Container();

    if (!manager.nameIsReady) return Container();

    if (member?.dates?.isEmpty ?? true) return Container();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Dates", style: styles.h2),
          const SizedBox(height: 10),
          ...member!.dates!.map((item) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 25, width: 65, child: Text(item.date)),
                Text(item.description ?? ''),
              ],
            );
          })
        ],
      ),
    );
  }
}
