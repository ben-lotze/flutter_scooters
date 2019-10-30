import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {

  final VoidCallback onPressed;
  final double buttonSize;
  final double iconSize;
  final Color backgroundColor;
  final IconData iconData;
  final Color iconColor;
  final EdgeInsets margin;


  CircleButton({this.onPressed,
    this.buttonSize = 36,
    this.iconSize = 24,
    this.backgroundColor = Colors.white,
    @required this.iconData,
    this.iconColor = Colors.black54,
    this.margin = const EdgeInsets.all(0),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: buttonSize,
      height: buttonSize,
      margin: margin,
      child: FloatingActionButton(
        backgroundColor: backgroundColor,
        child: IconButton(
          padding: EdgeInsets.all(0),
          icon: Icon(iconData, size: iconSize,),
          color: iconColor,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
