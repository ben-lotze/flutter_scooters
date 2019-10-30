/*
more blocs:
- NavigationBloc? -> may all go into mapsbloc
- CircApiBloc (containing CircApi)

 */

import 'package:circ_flutter_challenge/blocs/circ_api.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsBloc {

  CircApi _circApi;
  GoogleMapController _mapController;

  LatLng _center; // currentMapCenter --> can be a behaviour subject, default on creation time
  MapType _mapType = MapType.normal; // --> can be a behaviour subject with seeded default


  // steams






  void resetToUserPosition() {

  }

  // latitude, longitude
  void setPosition(LatLng position) {

  }

  // TODO: there is no addMarker method?
  void addMarkerToMap(LatLng marker) {
//    _mapController.
  }

  void addMarkers() {

  }


  /// dispose this bloc and release all its resources
  void dispose() {

  }



  /*
  2nd bloc for navigation and auto complete (search)?
  MapsNavigationBloc

  NO text controller
  getAutoCompleteSuggestions(String input) --> send everything that is entered --> UI is based on streams


   */



}



