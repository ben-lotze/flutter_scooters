import 'package:flutter/material.dart';

class VerticalImageTextButton extends StatelessWidget {

  final String imgAsset;
  final String text;
  final String tooltip;
  final bool drawBorder;
  final Function onTap;

  const VerticalImageTextButton({Key key, this.imgAsset, this.text, this.tooltip, this.drawBorder, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Tooltip(
        message: tooltip,
        child: Column(
          children: <Widget>[
            Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: Image.asset(imgAsset, width: 64, height: 64, fit: BoxFit.cover,),
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  border: drawBorder ? Border.all(width: 3, style: BorderStyle.solid, color: Colors.deepOrange)
                      : Border.all(width: 3, style: BorderStyle.solid, color: Colors.transparent)
              ),
            ),
            Text(text),
          ],
        ),
      ),
    );
  }
}
