import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
    final TextStyle heroStyle = Theme.of(context).textTheme.headline6.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        );

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
                    style: heroStyle,
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

    return CachedNetworkImage(imageUrl: widget.member.imageUrl);
  }
}

enum _PageStatus { Loading, Ready, Fail }
