import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../services/member_service.dart';
import '../stylesheet.dart';

class IndexScreen extends StatelessWidget {
  final Function onTap;

  const IndexScreen({@required this.onTap, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final service = context.watch<MemberService>();

    final heroStyle = Theme.of(context).textTheme.headline6.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        );

    const border = BorderSide(color: Color(0xffe6eee9));

    return Scaffold(
      backgroundColor: Style.colorBackground,
      body: (service.list?.isEmpty ?? true)
          ? Container()
          : SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      // physics: const ClampingScrollPhysics(),
                      padding: EdgeInsets.all(10),
                      itemCount: service.list.length,
                      itemBuilder: (context, index) {
                        final member = service.list[index];
                        return InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                top: border,
                                bottom: border,
                              ),
                            ),
                            child: ListTile(
                              title: Text(
                                member.index,
                                style: heroStyle,
                              ),
                              subtitle: (member.subIndex != null)
                                  ? Text(member.subIndex)
                                  : null,
                            ),
                            margin: EdgeInsets.only(bottom: 15),
                          ),
                          onTap: () {
                            onTap(member);
                          },
                        );
                      },
                    ),
                  ),
                  NameFilter()
                ],
              ),
            ),
    );
  }
}

class NameFilter extends StatefulWidget {
  @override
  _NameFilterState createState() => _NameFilterState();
}

class _NameFilterState extends State<NameFilter> {
  int _filter;
  @override
  Widget build(BuildContext context) {
    final service = context.watch<MemberService>();
    if (service.searchFilter?.isNotEmpty ?? false) return _notice(service);

    return _slider(service);
  }

  Widget _notice(MemberService service) => Container(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        color: Style.colorBrand,
        child: Row(
          children: [
            Expanded(
              child: Text(
                'All names with "${service.searchFilter}"',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _filter = 0;
                });
                service.searchFilter = null;
              },
            ),
          ],
        ),
      );

  Widget _slider(MemberService service) {
    final max =
        (service.searchKeys.isEmpty) ? 0 : service.searchKeys.length - 1;
    return Row(
      children: [
        Expanded(
          child: SliderTheme(
            data: SliderThemeData(
              // valueIndicatorColor: Colors.white,
              valueIndicatorTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            child: Slider(
              max: max.toDouble(),
              value: _filter?.toDouble() ?? 0.0,
              label: label(service),
              onChanged: (newValue) {
                setState(() {
                  _filter = newValue.round();
                });
              },
              onChangeEnd: (newValue) {
                service.searchFilter = label(service);
              },
              divisions: 26,
            ),
          ),
        ),
      ],
    );
  }

  String label(MemberService service) {
    if (_filter == null ||
        _filter < 0 ||
        _filter > service.searchKeys.length - 1) return "";

    return service.searchKeys[_filter];
  }
}
