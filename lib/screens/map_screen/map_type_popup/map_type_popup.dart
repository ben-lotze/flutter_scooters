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
                  tooltip: MapTypeImageButton.TOOLTIP_NORMAL,
                  imgAsset: "assets/img_icons/map_type_normal.png",
                  mapType: MapType.normal,
                  onTap: () => mapsBloc.updateMapState(mapType: MapType.normal),
                  context: parentContext,
                ),
                MapTypeImageButton(
                  text: "Satellite",
                  tooltip: MapTypeImageButton.TOOLTIP_SATELLITE,
                  imgAsset: "assets/img_icons/map_type_satellite.png",
                  mapType: MapType.satellite,
                  onTap: () => mapsBloc.updateMapState(mapType: MapType.satellite),
                  context: parentContext,
                ),
                MapTypeImageButton(
                  text: "Terrain" ,
                  tooltip: MapTypeImageButton.TOOLTIP_TERRAIN,
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
                  text: "Transport",
                  tooltip: "Would show public transportation layer (not implemented)",
                  imgAsset: "assets/img_icons/map_details_public_transport.jpg",
                  mapDetails: MapDetails.PUBLIC_TRANSPORT,
                  context: parentContext,
                ),
                MapDetailsImageButton(
                  text: "Traffic",
                  tooltip: "Would show traffic layer (not implemented)",
                  imgAsset: "assets/img_icons/map_details_traffic.jpg",
                  mapDetails: MapDetails.TRAFFIC,
                  context: parentContext,
                ),
                MapDetailsImageButton(
                  text: "Bike",
                  tooltip: "Would show layer for bike lanes (not implemented)",
                  imgAsset: "assets/img_icons/map_details_bike.jpg",
                  mapDetails: MapDetails.BIKE_LANES,
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
