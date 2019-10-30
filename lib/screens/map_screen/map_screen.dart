import 'dart:developer';

import 'package:circ_flutter_challenge/blocs/circ_api.dart';
import 'package:circ_flutter_challenge/blocs/maps_bloc.dart';
import 'package:circ_flutter_challenge/data/verhicle.dart';
import 'package:circ_flutter_challenge/screens/map_screen/buttons/button_current_position.dart';
import 'package:circ_flutter_challenge/screens/map_screen/buttons/button_layers.dart';
import 'package:circ_flutter_challenge/screens/map_screen/buttons/button_scanner.dart';
import 'package:circ_flutter_challenge/screens/map_screen/buttons/circle_button.dart';
import 'package:circ_flutter_challenge/screens/map_screen/search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

//  MapsBloc _mapBloc;



  BuildContext _context;


  void _onMapCreated(GoogleMapController controller, BuildContext context) async {
    Provider.of<MapsBloc>(context).mapControllerSink.add(controller);
  }

  @override
  Widget build(BuildContext context) {

    _context = context;
    return Provider(
      builder: (context) => MapsBloc.create(),

      // need new context to find bloc via context
      child: Builder(
        builder: (context) => Scaffold(
          body: Stack(

            children: <Widget>[

              // TODO: needs to  be refreshed based on current position --> Bloc with current position etc + StreamBuilder?
              // Just send this GoogleMap as Widget from Bloc? -> or manage all attributes over there?
              // callback to Block: map tapped --> unfocus input, revert to Maps default overlays (in case they changed)
              StreamBuilder<MapState>(
                stream: Provider.of<MapsBloc>(context).mapStateStream,
                builder: (context, snapshot) {

                  Offset centerOffset = MediaQuery.of(context).size.center(Offset(0,0));
                  print("centerOffset=$centerOffset");

                  print("new map state");
                  // TODO: this is not optimal --> there may be different updates: only zoom, only position, ... -> or: only use for reposition after search?
                  if (snapshot.hasData) {
                    MapState mapState = snapshot.data;
                    print("new map state: $mapState");
                    return GoogleMap(
                      onMapCreated: (mapController) => _onMapCreated(mapController, context),
                      mapType: mapState.mapType,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      mapToolbarEnabled: false,
                      initialCameraPosition: CameraPosition(
                        target: mapState.mapCenter,
                        zoom: 14.0,
                      ),
                      markers: mapState.markers,
                    );
                  }

                  // TODO: default not finished!
                  return Container();
                }
              ),

              /*
              TODO: UI controls:
              - layers button (map style) -> top right, smaller
              - position, below layers, same smaller size
              - +/- buttons
              - mapToolbar is android only -> implement manually

              - scanner button should animate out to bottom when starting search?
               */


              // scanner
              Align(
                alignment: Alignment.bottomCenter,
                child: ScannerButton(),
              ),


              // current position
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  margin: EdgeInsets.only(right: 24, bottom: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      LayersButton(),
                      SizedBox(height: 8,),
                      CurrentPositionButton(),
                    ],

                  ),
                )
              ),

              SearchBar(),
            ],
          ),
        ),
      ),
    );
  }





  /*
  TODO info card
  top left: id        top right: battery

  Price:
  1 € + X € / 1min

  How to use -> take images from apk

  drag to unlock (full width) --> better name: drag to reserve
  (will be reserved for 15 minutes, after that it's again available for anybody else)



  TODO: needs to open based on stream from bloc
   */


  void showInfoCard(Vehicle vehicle) {
    showModalBottomSheet(context: _context, builder: (context) {
      return Container(
        child: new Wrap(
          children: <Widget>[
            new ListTile(
                leading: new Icon(Icons.perm_identity),
                title: new Text('id'),
                onTap: () => {}
            ),
            new ListTile(
              leading: new Icon(Icons.directions_bike),
              title: new Text('name'),
              onTap: () => {},
            ),
          ],
        ),
      );
    }
    );

  }
}
