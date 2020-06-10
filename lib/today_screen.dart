import 'dart:async';

import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:cached_network_image/cached_network_image.dart';
import './services/cloud_service.dart';
import './services/store_service.dart';
import 'login_screen.dart';
import 'list_screen.dart';
import 'models.dart';
import 'stylesheet.dart';

class TodayScreen extends StatefulWidget {
  @override
  _TodayScreenState createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> with Authentication {
  PageStatus _status = PageStatus.Loading;
  List<Member> _list;
  Member _member;
  bool _nameIsReady = false;
  Size _screen = Size.square(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      floatingActionButton: FloatingActionButton(
          child: new Icon(Icons.list),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ListScreen(_list)),
            );
          }),
      body: _body,
    );
  }

  get _body {
    return new RefreshIndicator(
      child: ListView(
        children: <Widget>[
          Stack(
            children: [
              Column(
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 1.33,
                    // child: (_status == PageStatus.Ready) ? _image : Container(),
                    child: _image,
                  ),
                  // enough space for two lines of title styled text
                  Container(height: 60.0),
                ],
              ),
              _name,
            ],
          ),
          _description,
        ],
      ),
      onRefresh: () async {
        setState(() {
          _status = PageStatus.Loading;
          _nameIsReady = true;
        });
        await fetchListAndDisplay();
      },
    );
  }

  get _image {
    if (_member?.imageUrl == null) return Container();

    return CachedNetworkImage(
      imageUrl: _member.imageUrl,
      fadeInDuration: const Duration(milliseconds: 1500),
    );

    // return Image.network(
    //   _member.imageUrl,
    //   frameBuilder: (BuildContext context, Widget child, int frame,
    //       bool wasSynchronouslyLoaded) {
    //     if (wasSynchronouslyLoaded) {
    //       return child;
    //     }
    //     return AnimatedOpacity(
    //       child: child,
    //       opacity: frame == null ? 0 : 1,
    //       duration: const Duration(milliseconds: 500),
    //       curve: Curves.easeOut,
    //     );
    //   },
    // );
  }

  get _name {
    return Container(
      width: _screen.width,
      height: 60 + _screen.width * 0.75,
      child: AnimatedAlign(
        curve: Curves.easeInQuad,
        duration: Duration(milliseconds: 500),
        alignment: (_nameIsReady) ? Alignment.bottomLeft : Alignment.center,
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Text(
            (_nameIsReady)
                ? "${_member.name}\n "
                : "Today we are praying for ...",
            style: Style.h2,
            maxLines: 2,
          ),
        ),
      ),
    );
  }

  get _description {
    if (!_nameIsReady) return Container();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 40.0),
      child: Text(_member.description ?? ""),
    );
  }

  get _title {
    final today = DateTime.now();
    return formatDate(today, [DD, ', ', d, ' ', MM]);
  }

  setMember() {
    _member = Member.forToday(_list);
    if (_member == null) return;
    Timer(Duration(seconds: 1), () {
      setState(() {
        _nameIsReady = true;
      });
    });
  }

  Future fetchListAndDisplay() async {
    try {
      _list = await cloud.fetchMembers();
      setMember();
      setState(() {
        _status = PageStatus.Ready;
      });
    } catch (e) {
      setState(() {
        _status = PageStatus.Fail;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      _screen = MediaQuery.of(context).size;
      await authenticate(context);
      await fetchListAndDisplay();
    });
  }
}

enum PageStatus { Loading, Ready, Fail }

/// provided as mixin so it can be moved to any of the app's screens
mixin Authentication {
  Future authenticate(BuildContext context) async {
    final store = await CcwStore.create();

    if (!store.hasKeys) {
      final keys = await Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
      store.apiKey = keys[0];
      store.token = keys[1];
    }

    cloud.setAuth(store.apiKey, store.token);
  }
}
