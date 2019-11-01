import 'dart:async';

import 'package:circ_flutter_challenge/blocs/maps_bloc.dart';
import 'package:circ_flutter_challenge/data/verhicle.dart';
import 'package:circ_flutter_challenge/screens/map_screen/vehicle_info_popup.dart';
import 'package:circ_flutter_challenge/screens/map_screen/buttons/current_position_button.dart';
import 'package:circ_flutter_challenge/screens/map_screen/buttons/layers_button.dart';
import 'package:circ_flutter_challenge/screens/map_screen/buttons/scanner_button.dart';
import 'package:circ_flutter_challenge/screens/map_screen/search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}


class _MapScreenState extends State<MapScreen> {

  /// will show popup for incoming vehicle
  StreamController<Vehicle> _vehicleInfoPopupController; // TODO: or subject to be consistent

  @override
  void initState() {
    super.initState();
    print("initializing vehicle popup sink");
    _vehicleInfoPopupController = StreamController.broadcast();
    _vehicleInfoPopupController.stream.listen((vehicle) {
      print("info popup stream: incoming id=${vehicle.id}");
      _showVehicleInfoCard(vehicle, this.context);        // TODO: context necessary for dialog -> find better way?
      // TODO: click should not center map (that is confusing for the user), only change camera if marker would be hidden
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
//        backgroundColor: Colors.transparent,

        body: Builder(
          builder: (context) => Stack(

              children: <Widget>[

                // TODO: maybe StreamBuilder is not necessary here? (is this ever refreshed?)
                // TODO: needs to  be refreshed based on current position --> Bloc with current position etc + StreamBuilder?
                // Just send this GoogleMap as Widget from Bloc? -> or manage all attributes over there?
                // callback to Block: map tapped --> unfocus input, revert to Maps default overlays (in case they changed)
                StreamBuilder<MapState>(
                  stream: Provider.of<MapsBloc>(context).mapStateStream,
                  builder: (context, snapshot) {

                    Provider.of<MapsBloc>(context).vehicleInfoPopupSink = _vehicleInfoPopupController.sink;
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
                          zoom:  MapsBloc.DEFAULT_ZOOM_LEVEL,
                        ),
                        markers: mapState.markers,
                      );
                    }

                    // TODO: default behavior not finished! -> must not just be a container
                    return Container();
                  }
                ),

                /*  TODO: UI controls:
                - +/- buttons
                - scanner button should animate out to bottom when starting search?
                 */

                SearchBar(),

                // TODO: all bottom icons could go into one row with three columns (margin only once)

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
                        SizedBox(height: 8),
                        CurrentPositionButton(),
                      ],
                    ),
                  )
                ),



              ],
            ),
          ),
      ),

    );
  }


  void _onMapCreated(GoogleMapController controller, BuildContext context) async {
    // update bloc with map controller to be able to send updates from the bloc
    Provider.of<MapsBloc>(context).mapControllerSink.add(controller);
  }


  // TODO: should NOT be modal dialog --> two clicks to select different vehicle
  void _showVehicleInfoCard(Vehicle vehicle, BuildContext context) {
    showBottomSheet(
      elevation: 16,
      backgroundColor: Colors.transparent,
      shape: null,      // TODO: NO
      context: context,
      builder: (context) => VehicleInfoPopup(vehicle),
    );
  }


  @override
  void dispose() {
    super.dispose();
    _vehicleInfoPopupController.close();
  }

}
