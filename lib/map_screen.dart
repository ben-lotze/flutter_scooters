import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController mapController;

  LatLng _center = const LatLng(45.521563, -122.677433);


  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

    Marker marker = Marker(
      markerId: null,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),  // replaceable with custom Widget?

    );
  }

  @override
  Widget build(BuildContext context) {
    log("recreating with lat=${_center.latitude}, long=${_center.longitude}");
    return Scaffold(
//      appBar: AppBar(
//        title: Text('Circ Flutter Challenge'),
//        backgroundColor: Colors.green[700],
//      ),
      body: Stack(
        children: <Widget>[

          // TODO: needs to  be refreshed based on current position --> Bloc with current position etc + StreamBuilder?
          // Just send this GoogleMap as Widget from Bloc? -> or manage all attributes over there?
          // callback to Block: map tapped --> unfocus input, revert to Maps defaul overlays (in case they changed)
          GoogleMap(
            onMapCreated: _onMapCreated,    // TODO: callback in this class
//            mapType: MapType.satellite,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            mapToolbarEnabled: true,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            ),


          ),

          /*
          TODO: UI controls:
          - layers button (map style) -> top righ, smaller
          - position, below layers, same smaller size
          - +/- buttons
          - mapToolbar is android only -> implement manually

          - scanner button should animate out to bottom when starting search?
           */

          Align(
            alignment: Alignment.topCenter,
            child: Container(
//              height: 48,   // TODO: is overridden by decoration contentPadding? how to specify height and center text?
              margin: EdgeInsets.only(top: 32, left: 8, right: 8),

              // TODO: make unfocus work (clicking anywhere else)
              // TODO: autocomplete with maps data
              // TODO maybe put into transparent AppBar --> may work with transparent notification bar (no SafeArea! looks worse)
              child: TextFormField(
                textAlign: TextAlign.start,
                
                maxLines: 1,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(16),
                  filled: true,
                  fillColor: Colors.white,
                  focusColor: Colors.black54,
                  hoverColor: Colors.black54,

                  hintText: "Search",
                  suffixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 1.0, color: Colors.black54, style: BorderStyle.solid),
                    borderRadius: BorderRadius.all(Radius.circular(8))
                  ),
                ),
              ),
            ),
          ),


          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: 24),
              child: FloatingActionButton(
                child: IconButton(icon: Icon(Icons.camera)),
              ),
            ),
          ),

          // current position
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: EdgeInsets.only(right: 24, bottom: 24),
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: Icon(Icons.my_location),
                  color: Colors.black38,
                ),
                onPressed: () async {
                  // TODO: move to Bloc # getCurrentPosition OR just make geolocator public member? make it flexible
                  Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                  setState(() {
                    _center = LatLng(position.latitude, position.longitude);
                  });
                  mapController.moveCamera(CameraUpdate.newLatLng(_center));
                },
              ),
            ),
          ),

        ],
      ),
    );
  }
}
