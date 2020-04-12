import 'package:flutter/material.dart';

class GradientAppBar extends StatelessWidget implements PreferredSizeWidget{

  String title;
  final double _preferredHeight = 100.0;
  Color gradientBegin, gradientEnd;

  GradientAppBar({this.title,this.gradientBegin,this.gradientEnd}):
      assert(title != null),
        assert(gradientBegin != null),
        assert(gradientEnd != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _preferredHeight,
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 20.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            gradientBegin,
            gradientEnd
          ]
        )
      ),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          letterSpacing: 10.0,
          fontSize: 20.0,
          fontWeight: FontWeight.w500
        ),
      ),
    );

  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(_preferredHeight);
}
