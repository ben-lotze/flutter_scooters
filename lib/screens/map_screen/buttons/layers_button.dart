import 'package:circ_flutter_challenge/generic_widgets/circle_button.dart';
import 'package:circ_flutter_challenge/screens/map_screen/map_type_popup/map_type_popup.dart';
import 'package:flutter/material.dart';

class LayersButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return CircleButton(
      iconData: Icons.layers,
      heroTag: "layers_button",
      onPressed: () => _onPressed(context),
    );
  }

  void _onPressed(BuildContext parentContext) async {
    showDialog(
        context: parentContext,
        builder: (context) => MapTypePopup(parentContext: parentContext)
    );
  }

}
