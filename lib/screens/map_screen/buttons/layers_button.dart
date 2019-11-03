import 'package:circ_flutter_challenge/generic_widgets/circle_button.dart';
import 'package:circ_flutter_challenge/screens/map_screen/map_type_popup/map_type_popup.dart';
import 'package:flutter/material.dart';

class MapLayersButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return CircleButton(
      key: Key("map_layers_button"),
      tooltip: "Change map layers and settings",
      iconData: Icons.layers,
      heroTag: "map_layers_button",
      onPressed: () => _onPressed(context),
    );

    // TODO: bug in Flutter? integration test fails when using the custom CircleButton (as above) and trying to find it via key
    // "DriverError: Error in Flutter application: Uncaught extension error while executing tap: Bad state: Too many elements"
    // not correct as there should be only one widget with that key when specifying it as parameter here.
    // This is not nice, as it prevents code re-use.
    // Workaround: specifying and then finding by tooltip works. Reverted to CircleButton.

//    return Container(
//      width: 32,
//      height: 32,
//      margin: EdgeInsets.all(0),
//      child: FloatingActionButton(
//        key: Key("map_layers_button"),
//        tooltip: "Change map layers and settings",
//        backgroundColor: Colors.white,
//        heroTag: "map_layers_button",
//        child: IconButton(
//          key: this.key,
//          padding: EdgeInsets.all(0),
//          icon: Icon(Icons.layers, size: 24,),
//          color: Colors.black54,
//        ),
//        onPressed: () => _onPressed(context),
//      ),
//    );
  }

  void _onPressed(BuildContext parentContext) async {
    showDialog(
        context: parentContext,
        builder: (context) => MapTypePopup(parentContext: parentContext)
    );
  }

}
