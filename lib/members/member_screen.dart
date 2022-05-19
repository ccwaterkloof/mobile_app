import 'package:provider/provider.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'models.dart';
import 'member_service.dart';
import '../stylesheet.dart';

class MemberScreen extends StatelessWidget {
  final Member? member;
  final bool isTodayMember;

  const MemberScreen(this.member, {Key? key, required this.isTodayMember})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final service = context.watch<MemberService>();
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
                  alignment: (service.nameIsReady)
                      ? Alignment.bottomLeft
                      : Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Text(
                      (service.nameIsReady)
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
          _description(service),
          _dates(service),
        ],
      ),
    );
  }

  String? get _title {
    if (member == null) return "";

    final today = DateTime.now();
    if (isTodayMember) return formatDate(today, [DD, ', ', d, ' ', MM]);
    return member!.title;
  }

  Widget get _image {
    if (member?.imageUrl == null) return Container();

    return CachedNetworkImage(
      imageUrl: member!.imageUrl!,
      fadeInDuration: const Duration(milliseconds: 1500),
    );
  }

  Widget _description(MemberService service) {
    if (!service.nameIsReady) return Container();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      child: Text(member?.description ?? ""),
    );
  }

  Widget _dates(MemberService service) {
    if (isTodayMember) return Container();
    if (!service.nameIsReady) return Container();
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
