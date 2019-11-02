import 'package:circ_flutter_challenge/blocs/maps_bloc.dart';
import 'package:circ_flutter_challenge/screens/map_screen/map_type_popup/map_details_image_button.dart';
import 'package:circ_flutter_challenge/screens/map_screen/map_type_popup/map_type_image_button.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapTypePopup extends StatelessWidget {

  final BuildContext parentContext;

  const MapTypePopup({
    Key key,
    @required this.parentContext
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MapsBloc mapsBloc = Provider.of<MapsBloc>(this.parentContext);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
      elevation: 8,
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("MAP TYPE", style: TextStyle(letterSpacing: 1.4, fontWeight: FontWeight.bold,), textAlign: TextAlign.start,),

            SizedBox(height: 8,),

            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                MapTypeImageButton(
                  text: "Normal",
                  imgAsset: "assets/img_icons/map_type_normal.png",
                  mapType: MapType.normal,
                  onTap: () => mapsBloc.updateMapState(mapType: MapType.normal),
                  context: parentContext,
                ),
                MapTypeImageButton(
                  text: "Satellite" ,
                  imgAsset: "assets/img_icons/map_type_satellite.png",
                  mapType: MapType.satellite,
                  onTap: () => mapsBloc.updateMapState(mapType: MapType.satellite),
                  context: parentContext,
                ),
                MapTypeImageButton(
                  text: "Terrain" ,
                  imgAsset: "assets/img_icons/map_type_terrain_512.png",
                  mapType: MapType.terrain,
                  onTap: () => mapsBloc.updateMapState(mapType: MapType.terrain),
                  context: parentContext,
                ),
              ],
            ),

            SizedBox(height: 24,),

            Text("MAP DETAILS", style: TextStyle(letterSpacing: 1.4, fontWeight: FontWeight.bold,), textAlign: TextAlign.start,),

            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                MapDetailsImageButton(
                  text: "Traffic",
                  imgAsset: "assets/img_icons/map_type_normal.png",
                  mapDetails: MapDetails.TRAFFIC,
                  onTap: () => () {
                    // no additional adtions atm
                    },
                  context: parentContext,
                ),

              ],
            ),


          ],
        ),
      ),
    );
  }

}
