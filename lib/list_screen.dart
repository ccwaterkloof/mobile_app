import 'package:flutter/material.dart';
import 'models.dart';
import 'member_screen.dart';

class ListScreen extends StatefulWidget {
  // TODO: move to shared state
  final List<Member> list;

  ListScreen(this.list);

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CCW Family"),
      ),
      backgroundColor: Color.fromRGBO(240, 240, 240, 1),
      body: ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount: widget.list.length,
          itemBuilder: (context, index) {
            return InkWell(
              child: Card(
                child: ListTile(
                  title: Hero(
                    tag: widget.list[index].name,
                    child: Text(widget.list[index].name),
                    // contentPadding: EdgeInsets.only(left: 20.0, right: 50.0),
                  ),
                ),
                margin: EdgeInsets.only(bottom: 15.0),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MemberScreen(widget.list[index])),
                );
              },
            );
          }),
    );
  }
}
