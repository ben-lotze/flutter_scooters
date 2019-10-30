import 'package:circ_flutter_challenge/blocs/maps_bloc.dart';
import 'package:circ_flutter_challenge/screens/map_screen/buttons/circle_button.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class LayersButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircleButton(
      iconData: Icons.layers,
      onPressed: () => _onPressed(context),
    );
  }

  void _onPressed(BuildContext context) async {
    MapsBloc mapsBloc = Provider.of<MapsBloc>(context);
    // TODO: finish map type
    Dialog dialog = Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FlatButton(child: Text("Default"), onPressed: () => mapsBloc.updateMapState(mapType: MapType.normal),),
          FlatButton(child: Text("Satelite"), onPressed: () => mapsBloc.updateMapState(mapType: MapType.satellite),),
        ],
      ),
    );
    showDialog(context: context, builder: (context) => dialog);
  }
}