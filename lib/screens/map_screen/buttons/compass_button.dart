import 'package:circ_flutter_challenge/blocs/maps_bloc.dart';
import 'package:circ_flutter_challenge/generic_widgets/circle_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CompassButton extends StatelessWidget {

  final BuildContext parentContext;

  const CompassButton({Key key, this.parentContext}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MapsBloc mapsBloc = Provider.of<MapsBloc>(parentContext);

    return StreamBuilder<MapState>(
      stream: mapsBloc.mapStateStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          double cameraBearing = snapshot.data.cameraPosition.bearing;

          return Transform.rotate(
            angle: cameraBearing,
            child: CircleButton(
              heroTag: "compass_button",
              iconData: Icons.arrow_upward,
              onPressed: () => mapsBloc.onResetNorthPressed(),
            ),
          );

        }
        // just show nothing in all other cases
        return Container();
      }
    );
  }
}
