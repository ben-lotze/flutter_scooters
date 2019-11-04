import 'dart:async';

import 'package:circ_flutter_challenge/blocs/maps_bloc.dart';
import 'package:circ_flutter_challenge/data/verhicle.dart';
import 'package:circ_flutter_challenge/generic_widgets/circle_button.dart';
import 'package:circ_flutter_challenge/screens/map_screen/buttons/compass_button.dart';
import 'package:circ_flutter_challenge/screens/map_screen/buttons/current_position_button.dart';
import 'package:circ_flutter_challenge/screens/map_screen/buttons/layers_button.dart';
import 'package:circ_flutter_challenge/screens/map_screen/buttons/scanner_button.dart';
import 'package:circ_flutter_challenge/screens/map_screen/search_bar.dart';
import 'package:circ_flutter_challenge/screens/map_screen/vehicle_info_popup.dart';
import 'package:circ_flutter_challenge/screens/side_drawer/left_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}


class _MapScreenState extends State<MapScreen> {

  /// will show popup for one incoming vehicle
  StreamController<Vehicle> _vehicleInfoPopupController;
  bool _vehiclePopupActive = false;


  @override
  void initState() {
    super.initState();
    _vehicleInfoPopupController = StreamController.broadcast();
    _vehicleInfoPopupController.stream.listen((vehicle) {
      _showVehicleInfoCard(vehicle, this.context);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Provider(
      builder: (context) {
        MapsBloc bloc = MapsBloc.create();
        bloc.vehicleInfoPopupSink = _vehicleInfoPopupController.sink;
        return bloc;
      },

      // need new context to find bloc via context
      child: Scaffold(
        drawer: LibrarySideDrawer(),
        body: Builder(
          builder: (context) {
            MapsBloc mapsBloc = Provider.of<MapsBloc>(context);
            return Stack(
              children: <Widget>[

                // map view
                StreamBuilder<MapState>(
                    stream: mapsBloc.mapStateStream,
                    builder: (context, snapshot) {
                      // bloc needs sink to open vehicle popup
                      mapsBloc.vehicleInfoPopupSink = _vehicleInfoPopupController.sink;

                      if (snapshot.hasData) {
                        MapState mapState = snapshot.data;
                        CameraPosition cameraPosition = CameraPosition(
                          bearing: mapState.cameraPosition?.bearing ?? 0,
                          target: mapState.mapCenter,
                          zoom:  MapsBloc.DEFAULT_ZOOM_LEVEL,
                        );
                        mapsBloc.updateMapState(cameraPosition: cameraPosition, updateMapView: false);

                        return GoogleMap(
                          onMapCreated: (mapController) => _onMapCreated(mapController, context),
                          zoomGesturesEnabled: true,
                          myLocationEnabled: true,
                          myLocationButtonEnabled: false,
                          mapToolbarEnabled: false,
                          compassEnabled: false,
                          onCameraMove: (position) => mapsBloc.updateMapState(cameraPosition: position, updateMapView: false),
                          trafficEnabled: false,

                          onTap: (LatLng tapPosition) {
                            mapsBloc.mapTapped();
                            if (_vehiclePopupActive) {
                              Navigator.of(context).pop();
                            }
                          },
                          // controllable by bloc
                          markers: mapState.markers,
                          mapType: mapState.mapType,
                          initialCameraPosition: cameraPosition,
                        );
                      }

                      return Container();
                    }
                ),

                SearchBar(),

                // overlay icons
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      // left side
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          CircleButton(
                            key: Key("zoom_in_button"),
                            tooltip: "Zoom in",
                            iconData: Icons.zoom_in,
                            onPressed: () => Provider.of<MapsBloc>(context).zoomIn(),),
                          SizedBox(height: 8),
                          CircleButton(
                            key: Key("zoom_out_button"),
                            tooltip: "Zoom out",
                            iconData: Icons.zoom_out,
                            onPressed: () => Provider.of<MapsBloc>(context).zoomOut(),
                          ),
                        ],
                      ),
                      ScannerButton(),
                      // right side
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          CompassButton(parentContext: context, ),
                          SizedBox(height: 8),
                          MapLayersButton(),
                          SizedBox(height: 8),
                          CurrentPositionButton(),
                        ],
                      ),
                    ],

                  ),
                ),


              ],
            );
          },
          ),
      ),

    );
  }


  void _onMapCreated(GoogleMapController controller, BuildContext context) {
    // update bloc with map controller to be able to send updates from the bloc
    Provider.of<MapsBloc>(context).mapControllerSink.add(controller);
  }


  void _showVehicleInfoCard(Vehicle vehicle, BuildContext context) {
    showBottomSheet(
      elevation: 16,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => VehicleInfoPopup(vehicle),
    );
    _vehiclePopupActive = true;
  }


  @override
  void dispose() {
    super.dispose();
    _vehicleInfoPopupController.close();
  }

}
