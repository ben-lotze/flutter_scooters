import 'package:circ_flutter_challenge/blocs/maps_bloc.dart';
import 'package:circ_flutter_challenge/screens/map_screen/buttons/circle_button.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class CurrentPositionButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return CircleButton(
      iconData: Icons.my_location,
      heroTag: "current_position_button",
      onPressed: () => _onPressed(context),
    );
  }

  void _onPressed(BuildContext context) async {
    Provider.of<MapsBloc>(context).resetToUserPosition();
  }
}
