import 'package:flutter/material.dart';
import 'stylesheet.dart';
import 'models.dart';

class MemberScreen extends StatefulWidget {
  final Member member;
  MemberScreen(this.member);

  @override
  _MemberScreenState createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> {
  _PageStatus _status = _PageStatus.Loading;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.member.name),
      ),
      body: ListView(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AspectRatio(
                aspectRatio: 1.33,
                child: _image,
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Hero(
                  tag: widget.member.name,
                  child: Text(
                    "${widget.member.name}",
                    textAlign: TextAlign.left,
                    style: Style.h2,
                    maxLines: 2,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(widget.member.description ?? ""),
              ),
            ],
          ),
        ],
      ),
    );
  }

  get _image {
    if (widget.member.imageUrl == null) return Container();

    return Image.network(
      widget.member.imageUrl,
      frameBuilder: (BuildContext context, Widget child, int frame,
          bool wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) {
          return child;
        }
        return AnimatedOpacity(
          child: child,
          opacity: frame == null ? 0 : 1,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      },
    );
  }
}

enum _PageStatus { Loading, Ready, Fail }
