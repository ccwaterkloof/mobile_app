import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:ccw/services/member_service.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final service = context.watch<MemberService>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: service.reportList.length,
                itemBuilder: (context, i) {
                  return ListTile(
                    title: Text(service.reportList[i].title),
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

abstract class TestHelper {
  int lastTestTap = DateTime.now().millisecondsSinceEpoch;
  int consecutiveTestTaps = 0;

  void detectSecretGesture(BuildContext context) {
    int now = DateTime.now().millisecondsSinceEpoch;
    if (now - lastTestTap < 300) {
      consecutiveTestTaps++;
      if (consecutiveTestTaps > 4) {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const ReportScreen();
        }));
      }
    } else {
      consecutiveTestTaps = 0;
    }
    lastTestTap = now;
  }
}
