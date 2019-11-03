/*
more blocs:
- NavigationBloc? -> may all go into mapsbloc
- CircApiBloc (containing CircApi)

 */

import 'dart:async';
import 'dart:collection';
import 'dart:math' as math;

import 'package:circ_flutter_challenge/blocs/circ_api.dart';
import 'package:circ_flutter_challenge/data/verhicle.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';

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
    centerToCurrentUserPosition();
    List<Vehicle> vehicles = await _circApi.getVehicles();
    vehicles.forEach((vehicle) {
      _vehicleById[vehicle.id] = vehicle;
    });
    addMapMarkersForVehicles(vehicles);
  }

  Map<int, Vehicle> _vehicleById = HashMap();
  Map<MarkerId, Marker> _markersById = HashMap();
  MarkerId _lastTappedMarkerId; // needs to be reset to default color on each new tapped marker



  void addMapMarkersForVehicles(List<Vehicle> vehicles) {
    _markersById = HashMap();
    vehicles.forEach((vehicle) {
      Marker marker = _createMarker(vehicle, isSelected: false);
      _markersById[marker.markerId] = marker;
    });

    print("addMapMarkersForVehicles: ${_markersById.length} marked  created");
    updateMapState(markers: Set.of(_markersById.values));
  }

  // TODO: move somewhere else (or up in this class) -> Theme?
  double _inactiveMarkerHue = BitmapDescriptor.hueGreen - 20;
  double _activeMarkerHue = BitmapDescriptor.hueOrange;


  // TODO: on popup close -> need to unmark currently marked marker!
  Marker _createMarker(Vehicle vehicle, {@required bool isSelected, MarkerId markerId}) {
    MarkerId markerId = MarkerId(vehicle.id.toString());
    Marker marker = Marker(
      markerId: markerId,
      icon: BitmapDescriptor.defaultMarkerWithHue(isSelected ? _activeMarkerHue : _inactiveMarkerHue),  // TODO: replace with custom Widget
      position: LatLng(vehicle.latitude, vehicle.longitude),
      onTap: () {
//        print("tapped marker=$markerId for vehicle id=${vehicle.id} (lastTapped=$_lastTappedMarkerId)");

        // update currently tapped marker + reset last tapped marker to defaults
        _markersById[markerId] = _createMarker(vehicle, isSelected: true, markerId: markerId);
        if (_lastTappedMarkerId != null && _lastTappedMarkerId != markerId) {
          _markersById[_lastTappedMarkerId] = _createMarker(_vehicleById[int.parse(_lastTappedMarkerId.value)], isSelected: false, markerId: _lastTappedMarkerId);
        }
        updateMapState(markers: Set.of(_markersById.values), updateMapView: true);
        _lastTappedMarkerId = markerId;

        _vehicleInfoPopupSink.add(vehicle);
      },
      consumeTapEvents: true,
    );

    return marker;
  }


  // TODO TEST STYLING (maybe traffic, bike? -> NO, just which elements are on map)
  // TODO: test: possible with platform channel to Android/iOS map component (which gets embedded)?
  void testChangeStyle() {
//    _mapControllerSubject.value.setMapStyle(mapStyle);
  }


  Future<void> resetNorth() async {
//    print("resetNorth: ${_mapStateSubject.value}");
    await _mapControllerSubject.value.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        bearing: 0,
        target: _mapStateSubject.value.mapCenter,
        zoom: 14) // TODO, not always 14, current zoom! -_> must go into block on each camera change
    ));
  }

  // TODO: rename to --> position button pressed ot similar --> does two things
  void centerToCurrentUserPosition() async {
//    GoogleMapController controller = _mapControllerSubject.value;
//    if (controller == null) {
//      // should be logged
//      return;
//    }

    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    LatLng userLatLng = LatLng(position.latitude, position.longitude);
    updateMapState(mapCenter: userLatLng, updateMapView: false);  // no update: do with animation
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


  bool addMapDetails(MapDetails mapDetails) {
    // TODO: return value based on reaction of map? (if successful there ot not)
    MapState mapState = _mapStateSubject.value;
    bool added = mapState.addMapDetails(mapDetails);
//    _mapStateSubject.add(_mapStateSubject.value);
    updateMapState(updateMapView: true);
    return added;
  }

  bool removeMapDetails(MapDetails mapDetails) {
    bool removed = _mapStateSubject.value.mapDetails.remove(mapDetails);
    _mapStateSubject.add(_mapStateSubject.value);
    return removed;
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



  void zoomIn() {
//    updateMapState() TODO: zoom state --> should be updated from map via change of camera position (callback), same for zoomOut
    _mapControllerSubject.value.animateCamera(CameraUpdate.zoomIn());
  }

  void zoomOut() {
    _mapControllerSubject.value.animateCamera(CameraUpdate.zoomOut());
  }



  /// [updateMapView] Defaults to true. If true, the map view will be updated with the new values.
  /// Set to false to only update the data inside the bloc, e.g. if the new values have already been (or will be) applied differently.
  void updateMapState({
      LatLng mapCenter,
      MapType mapType,
      Set<Marker> markers,
      double zoomLevel,
      CameraPosition cameraPosition,
      bool updateMapView = true,
      }) {
    MapState mapState = _mapStateSubject.value;
//    print("updating mapState, old=$mapState");
    if (mapCenter != null) {
      mapState.mapCenter = mapCenter;
    }
    if (mapType != null) {
      mapState.mapType = mapType;
    }
    if (markers!= null) {
      mapState.markers = markers;
    }
    if (mapCenter != null) {
      mapState.zoomLevel = zoomLevel;
    }
    if (cameraPosition != null) {
      mapState.cameraPosition = cameraPosition;
    }

//    print("-> new mapState=$mapState");
    if (updateMapView) {
      _mapStateSubject.add(mapState);
    }
  }


  /// dispose this bloc and release all its resources
  void dispose() {
    _mapControllerSubject.close();
    _mapStateSubject.close();
  }



  /*
  2nd bloc for navigation and auto complete (search)?
  MapsNavigationBloc

  NO text controller
  getAutoCompleteSuggestions(String input) --> send everything that is entered --> UI is based on streams


   */



}



class MapState {

  LatLng mapCenter;
  MapType mapType;
  Set<MapDetails> _mapDetails;
  Set<Marker> markers;
  double zoomLevel;
  CameraPosition cameraPosition;

  MapState({
    this.mapCenter = const LatLng(0, 0),
    this.mapType = MapType.normal,
//    mapDetails = const {},
    this.markers = const {},
    this.zoomLevel = MapsBloc.DEFAULT_ZOOM_LEVEL,
    this.cameraPosition
  }) {
    this._mapDetails = HashSet();
  }


  get mapDetails => _mapDetails;
  bool addMapDetails(MapDetails mapDetails) {
    if (_mapDetails == null) {
      _mapDetails = Set.of([mapDetails]);
      return true;
    }
    return _mapDetails.add(mapDetails);
  }

  @override
  String toString() {
    return 'MapState{mapCenter: $mapCenter, mapType: $mapType, _mapDetails: $_mapDetails, markers: $markers, zoomLevel: $zoomLevel}';
  }


}



enum MapDetails {
  TRAFFIC,
}