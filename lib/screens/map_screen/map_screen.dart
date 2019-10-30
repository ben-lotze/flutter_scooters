import 'dart:developer';

import 'package:circ_flutter_challenge/blocs/circ_api.dart';
import 'package:circ_flutter_challenge/data/verhicle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController _mapController;

  Set<Marker> _markers;
  LatLng _currentMapCenter = const LatLng(45.521563, -122.677433);
  MapType _mapType = MapType.normal;

  BuildContext _context;


  void _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;

    List<Vehicle> vehicles = await CircApi().getVehicles();
    List<Marker> markers = List.generate(vehicles.length, (index) {
      Vehicle vehicle = vehicles.elementAt(index);
      return Marker(
        markerId: MarkerId(vehicle.id.toString()),
        position: LatLng(vehicle.latitude, vehicle.longitude),
        onTap: () {
          print("marker tapped for id=${vehicle.id}");
//          Scaffold.of(context).showSnackBar(SnackBar(content: Text("Clicked vehicle with id=${vehicle.id}"),));
          showInfoCard(vehicle);
        },
        consumeTapEvents: true,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),  // replaceable with custom Widget?
      );
    });

    setState(() {
      _markers = Set.of(markers);
    });
  }

  @override
  Widget build(BuildContext context) {
    log("recreating with lat=${_currentMapCenter.latitude}, long=${_currentMapCenter.longitude}");
    _context = context;
    return Scaffold(
//        drawerScrimColor: Colors.transparent,
//        backgroundColor: Colors.transparent,
//    extendBody: true,
//    primary: true,

      body: Stack(

        children: <Widget>[

          // TODO: needs to  be refreshed based on current position --> Bloc with current position etc + StreamBuilder?
          // Just send this GoogleMap as Widget from Bloc? -> or manage all attributes over there?
          // callback to Block: map tapped --> unfocus input, revert to Maps default overlays (in case they changed)
          GoogleMap(
            onMapCreated: _onMapCreated,    // TODO: callback in this class
            mapType: _mapType,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            mapToolbarEnabled: false,
            initialCameraPosition: CameraPosition(
              target: _currentMapCenter,
              zoom: 11.0,
            ),
            markers: _markers,


          ),

          /*
          TODO: UI controls:
          - layers button (map style) -> top righ, smaller
          - position, below layers, same smaller size
          - +/- buttons
          - mapToolbar is android only -> implement manually

          - scanner button should animate out to bottom when starting search?
           */

//        Align(
//          alignment: Alignment.topCenter,
//          child:
//        ),


        // scan
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: 24),
              child: FloatingActionButton.extended(
                icon: Image.asset("assets/icons/qrcode-scan.png", width: 24, height: 24, color: Colors.black54,),
                label: Text("Scan", style: TextStyle(fontSize: 16, color: Colors.black54),),

//                child: Image.asset("assets/icons/qrcode-scan.png", width: 32, height: 32,),
//                child: IconButton(
//                  icon: Icon(Icons.center_focus_weak, size: 36,),
//                  padding: EdgeInsets.all(0),
//                ),
              ),
            ),
          ),


          // current position
          Align(
            alignment: Alignment.bottomRight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[

                // layers
                Container(
                  width: 36,
                  height: 36,
                  margin: EdgeInsets.only(right: 24, bottom: 8),
                  child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      padding: EdgeInsets.all(0),
                      icon: Icon(Icons.layers, size: 24,),
                      color: Colors.black38,
                    ),
                    onPressed: () async {
                      // TODO: move to Bloc
                      setState(() {
                        _mapType = _mapType == MapType.normal ? MapType.satellite : MapType.normal;
                      });
                    },
                  ),
                ),

                // TODO: buttons need to go into separate Widget class
                // current position
                Container(
                  width: 36,
                  height: 36,
                  margin: EdgeInsets.only(right: 24, bottom: 24),
                  child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      padding: EdgeInsets.all(0),
                      icon: Icon(Icons.my_location, size: 24,),
                      color: Colors.black38,
                    ),
                    onPressed: () async {
                      // TODO: move to Bloc # getCurrentPosition OR just make geolocator public member? make it flexible
                      Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                      setState(() {
                        _currentMapCenter = LatLng(position.latitude, position.longitude);
                      });
                      _mapController.moveCamera(CameraUpdate.newLatLng(_currentMapCenter));
                    },
                  ),
                ),




              ],

            )
          ),




          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: AppBar(        // Add AppBar here only
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                child: Container(
                  height: 48,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      IconButton(icon: Icon(Icons.menu),),

                      Expanded(
                        child: TextFormField(
                          textAlign: TextAlign.start,
                          minLines: 1,
                          maxLines: 1,
                          decoration: InputDecoration(
                            hintText: "Enter destination",
                            contentPadding: EdgeInsets.all(8),
                            border: InputBorder.none,

                          ),


                        ),
                      ),

                      IconButton(icon: Icon(Icons.mic),),
                    ],
                  )
                ),
              ),
            ),
          ),



//          Positioned(
//            top: 0,
//            left: 0,
//            right: 0,
//            height: 48,
//            child: AppBar(
//
//
//              primary: false,
//              title: Card(
//                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
//                elevation: 8,
//                child: Container(
//                  height: 48,   // TODO: is overridden by decoration contentPadding? how to specify height and center text?
////                margin: EdgeInsets.only(top: 32, left: 8, right: 8),
////                decoration: BoxDecoration(
//////                  boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 4, offset: Offset(4, 4))],
////                  borderRadius: BorderRadius.all(Radius.circular(16)),
////                ),
//
//                  // TODO: make unfocus work (clicking anywhere else)
//                  // TODO: autocomplete with maps data
//                  // TODO maybe put into transparent AppBar --> may work with transparent notification bar (no SafeArea! looks worse)
//                  child: TextFormField(
//                    textAlign: TextAlign.start,
//
//                    maxLines: 1,
//                    decoration: InputDecoration(
//                      contentPadding: EdgeInsets.all(16),
//                      filled: true,
//                      fillColor: Colors.white,
//                      focusColor: Colors.black54,
//                      hoverColor: Colors.black54,
//                      border: InputBorder.none,
//
//                      hintText: "Search",
//                      suffixIcon: Icon(Icons.search),
//
////                  border: OutlineInputBorder(
////                    borderSide: BorderSide(width: 1.0, color: Colors.black54, style: BorderStyle.solid),
////                    borderRadius: BorderRadius.all(Radius.circular(8))
////                  ),
//                    ),
//                  ),
//                ),
//              ),
//
//              backgroundColor: Colors.transparent.withOpacity(0.0),
//              elevation: 8,
////              primary: true,
//              bottomOpacity: 0.0,
////        toolbarOpacity: 0.0,
//
//            ),
//          ),

        ],
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
