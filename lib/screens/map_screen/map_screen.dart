import 'dart:async';

import 'package:circ_flutter_challenge/blocs/maps_bloc.dart';
import 'package:circ_flutter_challenge/blocs/price_calculator_bloc.dart';
import 'package:circ_flutter_challenge/data/verhicle.dart';
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

//  MapsBloc _mapBloc;



  BuildContext _context;
  /// will show popup for incoming vehicle, will close on incoming null
  StreamController<Vehicle> _vehicleInfoPopupController; // TODO: or subject to be consistent

  @override
  void initState() {
    super.initState();
    print("initializing vehicle popup sink");
    _vehicleInfoPopupController = StreamController.broadcast();
    _vehicleInfoPopupController.stream.listen((vehicle) {
      print("info popup stream: incoming id=${vehicle.id}");
      showInfoCard(vehicle);
    });
  }



  @override
  Widget build(BuildContext context) {

    _context = context;
    return Provider(
      builder: (context) {
        MapsBloc bloc = MapsBloc.create();
        bloc.vehicleInfoPopupSink = _vehicleInfoPopupController.sink;
        return bloc;
      },

      // need new context to find bloc via context
      child: Builder(
        builder: (context) => Scaffold(
          body: Stack(

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
    Provider.of<MapsBloc>(context).mapControllerSink.add(controller);
  }



  /*
  TODO info card

  How to use -> take images from apk

  drag to unlock (full width) --> better name: drag to reserve
  (will be reserved for 15 minutes, after that it's again available for anybody else)

   */


  void showInfoCard(Vehicle vehicle) {
    showModalBottomSheet(context: _context, builder: (context) {

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[

          // id / battery
          Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[

              Text("ID: ${vehicle.id}"),
              Spacer(),
              Icon(Icons.battery_std),
              Text(" ${vehicle.batteryLevel}%"),
            ],
          ),

          // price info
          Provider(
            builder: (context) => PriceCalculatorBloc(),
            child: Builder(
              builder: (context) {
                PriceCalculatorBloc calculator = PriceCalculatorBloc();
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.euro_symbol),
                    SizedBox(width: 8),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Price:", style: TextStyle(fontWeight: FontWeight.bold),),
                        Text("Base price: ${calculator.formatPriceInEuro(calculator.basePriceInCents, vehicle.currency)} "
                            "+ ${calculator.formatPriceInEuro(vehicle.price, vehicle.currency)} / ${vehicle.priceTime}"),
                        Text("5 minutes: ${calculator.calculateFormattedPriceForDuration(vehicle.price, vehicle.currency, Duration(minutes: 5))}"),
                        Text("10 minutes: ${calculator.calculateFormattedPriceForDuration(vehicle.price, vehicle.currency, Duration(minutes: 10))}"),
                        Text("15 minutes: ${calculator.calculateFormattedPriceForDuration(vehicle.price, vehicle.currency, Duration(minutes: 15))}"),

                        //TODO: calculator/dragHandler for X minutes
                      ],
                    ),
                  ],
                );
              },
            ),
          ),


          // unlock slider
          //TODO: should have lock/unlock icon on destination (destination side changes from left to right)
          Container(
            width: MediaQuery.of(context).size.width - 32,
            height: 36,
            child: Stack(

              children: <Widget>[

                // background
                Container(
                  padding: EdgeInsets.all(0),
                  height: 36,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.deepOrange, width: 2)
                  ),
                ),

                Align(
                  alignment: Alignment.center,
                  child: Text("Drag to unlock"),
                ),

                // draggable
                Align(
                  alignment: Alignment.centerLeft,
                  child: Draggable(
                    axis: Axis.horizontal,
                    child: Container(width: 32, height: 32,
                      decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    feedback: Container(width: 32, height: 32,
                      decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    childWhenDragging: Container(height: 32, width: 32),
                    maxSimultaneousDrags: 1,
                    data: vehicle.id,
                    onDragCompleted: () {
                      print("Draggable: yay, drag completed");
                    },
                  ),
                ),

                // target
                Align(
                  alignment: Alignment.centerRight,
                  child: DragTarget<int>(
                    builder: (context, List<int> candidates, List<dynamic> rejected) {
                      return Container(width: 36, height: 36,

                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(color: Colors.deepOrange, width: 2, style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      );
                    },
                    onWillAccept: (data) {
                      print("DragTarget: dropping would be ok now");
                      return true;
                    },
                    onAccept: (data) {
                      print("DragTarget: drag acceped!!!!!!!!!");
                      // TODO: set bool accepted to true -> must all go into separate widget (can be checked in builder to switch widget after accepting)
                      //  TODO -> maybe create library for this
                    },
                  ),
                ),

              ],
            ),
          ),


        ],
      );

    });

  }
}
