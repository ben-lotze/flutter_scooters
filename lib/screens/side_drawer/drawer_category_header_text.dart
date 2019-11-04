import 'package:flutter/material.dart';

class DrawerCategoryHeaderText extends StatelessWidget {
  final String text;
  DrawerCategoryHeaderText.create(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
      child: Text(
        text,
        textAlign: TextAlign.left,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
