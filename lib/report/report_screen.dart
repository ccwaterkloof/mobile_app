import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

import 'package:ccw/members/member_manager.dart';

class ReportScreen extends StatelessWidget with GetItMixin {
  ReportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final manager = watchOnly((MemberManager m) => m);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: manager.reportList.length,
                itemBuilder: (context, i) {
                  return ListTile(
                    title: Text(manager.reportList[i].title),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReportGesture extends StatefulWidget {
  final Widget child;

  const ReportGesture({required this.child, Key? key}) : super(key: key);

  @override
  State<ReportGesture> createState() => _ReportGestureState();
}

class _ReportGestureState extends State<ReportGesture> {
  int lastTestTap = DateTime.now().millisecondsSinceEpoch;
  int consecutiveTestTaps = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        int now = DateTime.now().millisecondsSinceEpoch;
        if (now - lastTestTap < 300) {
          consecutiveTestTaps++;
          if (consecutiveTestTaps > 4) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ReportScreen();
            }));
          }
        } else {
          consecutiveTestTaps = 0;
        }
        lastTestTap = now;
      },
      child: widget.child,
    );
  }
}
