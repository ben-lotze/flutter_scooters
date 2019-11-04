import 'package:flutter/material.dart';

class DrawerListTile extends StatelessWidget{

  final String title;
  final Widget icon;
  final String popupText;

  DrawerListTile.create(this.title, this.icon, this.popupText);

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
        child: Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.transparent, width: 0.0)),
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
          child: Row(
            children: <Widget>[
              icon,
              SizedBox(width: 12),
              Text(title)
            ],
          ),
        ),
        onTap: () {
          Navigator.of(context).pop();  // close drawer
          Scaffold.of(context).hideCurrentSnackBar(reason: SnackBarClosedReason.dismiss);
          Scaffold.of(context).showSnackBar(SnackBar(content: Text(popupText), ));
        }
    );
  }


}