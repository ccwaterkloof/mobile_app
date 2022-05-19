import 'package:flutter/material.dart';

class ToolTipDates extends StatelessWidget {
  const ToolTipDates({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const tipColor = Color(0xee303030);
    return Positioned(
      right: 0,
      bottom: 200,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: tipColor,
            ),
            child: const Material(
              type: MaterialType.transparency,
              child: Text(
                "Pull here to see dates",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
            height: 10,
            child: ClipPath(
              clipper: TriangleClipper(),
              child: Container(color: tipColor, height: 10, width: 10),
            ),
          ),
        ],
      ),
    );
  }
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, size.height / 2);
    path.lineTo(0, size.height);
    // path.lineTo(size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(TriangleClipper oldClipper) => false;
}
