/*
more blocs:
- NavigationBloc? -> may all go into mapsbloc
- CircApiBloc (containing CircApi)

 */

import 'dart:async';

import 'package:circ_flutter_challenge/blocs/circ_api.dart';
import 'package:circ_flutter_challenge/data/verhicle.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:math' as math;

class MapsBloc {

  CircApi _circApi;

  StreamSink _vehicleInfoPopupSink;
  set vehicleInfoPopupSink(StreamSink sink) => _vehicleInfoPopupSink = sink;

  BehaviorSubject<GoogleMapController> _mapControllerSubject;
  StreamSink get mapControllerSink => _mapControllerSubject.sink;

  BehaviorSubject<MapState> _mapStateSubject;
  Stream get mapStateStream => _mapStateSubject.stream;

//  BehaviorSubject<LatLng> _mapCenterSubject;
//  BehaviorSubject<MapType> _mapTypeSubject;
//  BehaviorSubject<Marker> _mapMarkersSubject;

  // more
  // markerTapped

  static const double DEFAULT_ZOOM_LEVEL = 14;


  MapsBloc._internal() {
    _circApi = CircApi();

    _mapStateSubject = BehaviorSubject.seeded(MapState());  // TODO: with defaults, and last position (persisted)

    _mapControllerSubject = BehaviorSubject();
    _mapControllerSubject.listen((mapController) {
      print("map created");
      _onMapCreated(mapController);
    });


//    _mapCenterSubject = BehaviorSubject();
//    centerToCurrentUserPosition();

//    _mapTypeSubject = BehaviorSubject.seeded(MapType.normal);   // TODO: maybe reset to last used map type (persistent/settings)
  }

  factory MapsBloc.create() {
    return MapsBloc._internal();
  }


  // TODO: method like onMapPositionChanged --> may need new search (depending on which area has been searched)!!!!!!!!!!!!!!!!!!!!!!!
  // definitivly add this? but can not be searched from endpoint! --> just assume there was such a functionality

  void _onMapCreated(GoogleMapController controller) async {
    List<Vehicle> vehicles = await _circApi.getVehicles();
    vehicles.forEach((v) => print(v));

    List<Marker> markers = List.generate(vehicles.length, (index) {
      Vehicle vehicle = vehicles.elementAt(index);
      return Marker(
        markerId: MarkerId(vehicle.id.toString()),
        position: LatLng(vehicle.latitude, vehicle.longitude),
        onTap: () { // TODO: on tap, just put whatever is necessary into streams/subjects
          print("marker tapped for id=${vehicle.id}");
//          showInfoCard(vehicle);
          _vehicleInfoPopupSink.add(vehicle);
        },
        consumeTapEvents: true,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),  // replaceable with custom Widget?
      );
    });

    // TODO: add markers only once? or add each marker (more events)
//    _mapMarkersSubject.addStream(Stream.fromIterable(markers));

    // TODO: add method to make this faster --> all possible parameters in brackets {...}
//    MapState mapState = _mapStateSubject.value;
//    mapState.markers = Set.of(markers);
//    _mapStateSubject.add(mapState);

    updateMapState(markers: Set.of(markers));

    centerToCurrentUserPosition();
  }








  // TODO: rename to --> position button pressed ot similar --> does two things
  void centerToCurrentUserPosition() async {

    GoogleMapController controller = _mapControllerSubject.value;
    if (controller == null) {
      print("map controller still null, returning");
      return;
    }


    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    LatLng userLatLng = LatLng(position.latitude, position.longitude);
    print("map controller ok, will reset user position $userLatLng");
    _mapControllerSubject.value.animateCamera(CameraUpdate.newLatLng(userLatLng));
//    _mapControllerSubject.value.moveCamera(CameraUpdate.newLatLng(userLatLng));

//    print("\nuserLatLng: $userLatLng");
//    // TODO: try with .. and all in one line
//    LatLng currentMapLatLng = await _mapControllerSubject.value.getLatLng(ScreenCoordinate(x:206, y:342));
//    print("currentMapLatLng: $currentMapLatLng");
//
////    double latitudeDiff = (userLatLng.latitude - currentMapLatLng.latitude).abs();
////    double longitudeDiff = (userLatLng.longitude - currentMapLatLng.longitude).abs();
////    print("latitudeDiff=$latitudeDiff, longitudeDiff=$longitudeDiff");
////    if ( latitudeDiff <= 0.3
////        && longitudeDiff <= 0.3
////      ) {
////      print("reset: only zoom");
////      _mapControllerSubject.value.animateCamera(CameraUpdate.newLatLngZoom(userLatLng, _DEFAULT_ZOOM_LEVEL));
//////      _mapControllerSubject.value.animateCamera(CameraUpdate.zoomTo(_DEFAULT_ZOOM_LEVEL));
////    }
//
//    double distance = calculateDistance(userLatLng.latitude, userLatLng.longitude, currentMapLatLng.latitude, currentMapLatLng.longitude);
//    print("distace: $distance");
//    if (distance < 2) {
//      _mapControllerSubject.value.animateCamera(CameraUpdate.newLatLngZoom(userLatLng, _DEFAULT_ZOOM_LEVEL));
//    }
//    else {
//      print("only center map to $userLatLng");
//      _mapControllerSubject.value.animateCamera(CameraUpdate.newLatLng(userLatLng));
//
//    }




//    _mapStateSubject.sink.add(mapState);

//    _mapControllerSubject.value.animateCamera(CameraUpdate.zoomTo(14));
  }


  // TODO remove, use API
  double calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var c = math.cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p))/2;
    return 12742 * math.asin(math.sqrt(a));
  }


  // latitude, longitude
  void setPosition(LatLng position) {

  }

  // TODO: there is no addMarker method?
  void addMarkerToMap(LatLng marker) {

  }


  void createMarkersForVehicles() {
    // TODO: this one is ok ->
  }


  void addMarkers() {

  }

  void zoomIn() {
    _mapControllerSubject.value.animateCamera(CameraUpdate.zoomIn());
  }

  void zoomOut() {
    _mapControllerSubject.value.animateCamera(CameraUpdate.zoomOut());
  }


  updateMapState({
    LatLng mapCenter,
    MapType mapType,
    Set<Marker> markers,
    double zoomLevel,
  }) {
    MapState mapState = _mapStateSubject.value;
    print("updating mapState, old=$mapState");
    if (mapCenter != null) {
      mapState.mapCenter = mapCenter;
    }
    if (mapType != null) {
      mapState.mapType= mapType;
    }
    if (markers!= null) {
      mapState.markers = markers;
    }
    if (mapCenter != null) {
      mapState.zoomLevel = zoomLevel;
    }


    print("-> new mapState=$mapState");
    _mapStateSubject.add(mapState);
  }


  /// dispose this bloc and release all its resources
  void dispose() {
    _mapControllerSubject.close();
//    _mapTypeSubject.close();
//    _mapCenterSubject.close();
  }



  /*
  2nd bloc for navigation and auto complete (search)?
  MapsNavigationBloc

  NO text controller
  getAutoCompleteSuggestions(String input) --> send everything that is entered --> UI is based on streams


   */



}



// TODO alternative: multiple behaviour subjects --> just use their value in the map screen !!!!!!!!!

class MapState {

  LatLng mapCenter;
  MapType mapType;
  Set<Marker> markers;
  double zoomLevel;

  MapState({
    this.mapCenter = const LatLng(0, 0),
    this.mapType = MapType.normal,
    this.markers = const {},
    this.zoomLevel = MapsBloc.DEFAULT_ZOOM_LEVEL,
  });

  @override
  String toString() {
    return 'MapState{mapCenter: $mapCenter, mapType: $mapType, markers: $markers, zoomLevel: $zoomLevel}';
  }


}