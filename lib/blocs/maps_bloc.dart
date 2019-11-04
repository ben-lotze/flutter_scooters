import 'dart:async';
import 'dart:collection';

import 'package:circ_flutter_challenge/blocs/circ_api.dart';
import 'package:circ_flutter_challenge/data/verhicle.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';

class MapsBloc {

  static const double DEFAULT_ZOOM_LEVEL = 14;
  /// color of inactive markers
  static const double _inactiveMarkerHue = BitmapDescriptor.hueGreen - 20;
  /// color of the active marker
  static const double _activeMarkerHue = BitmapDescriptor.hueOrange;



  CircApi _circApi;

  /// map view will show info popup for incoming vehicle
  StreamSink<Vehicle> _vehicleInfoPopupSink;
  /// update the sink to be able to send vehicles to the map view
  set vehicleInfoPopupSink(StreamSink<Vehicle> sink) => _vehicleInfoPopupSink = sink;

  /// this map controller is used to control various specifics of the map view
  BehaviorSubject<GoogleMapController> _mapControllerSubject;
  /// update the map controller for the view
  StreamSink get mapControllerSink => _mapControllerSubject.sink;

  /// Holds various attributes which are relevant for the map view
  BehaviorSubject<MapState> _mapStateSubject;
  Stream get mapStateStream => _mapStateSubject.stream;


  Map<int, Vehicle> _vehicleById = HashMap(); // K=vehicleId (equal to value of markerId)
  Map<MarkerId, Marker> _markersById = HashMap();
  MarkerId _lastTappedMarkerId; // needs to be reset to default color on each new tapped marker



  MapsBloc._internal() {
    _circApi = CircApi();

    _mapStateSubject = BehaviorSubject.seeded(MapState());

    _mapControllerSubject = BehaviorSubject();
    _mapControllerSubject.listen((mapController) {
      _onMapCreated(mapController);
    });
  }

  factory MapsBloc.create() {
    return MapsBloc._internal();
  }



  void _onMapCreated(GoogleMapController controller) async {
    onCenterViewPressed();
    List<Vehicle> vehicles = await _circApi.getVehicles();
    vehicles.forEach((vehicle) {
      _vehicleById[vehicle.id] = vehicle;
    });
    _addMapMarkersForVehicles(vehicles);

    onCenterViewPressed();
  }


  void _addMapMarkersForVehicles(List<Vehicle> vehicles) {
    _markersById = HashMap();
    vehicles.forEach((vehicle) {
      Marker marker = _createMarker(vehicle, isSelected: false);
      _markersById[marker.markerId] = marker;
    });

    updateMapState(markers: Set.of(_markersById.values));
  }


  Marker _createMarker(Vehicle vehicle, {@required bool isSelected, MarkerId markerId}) {
    MarkerId markerId = MarkerId(vehicle.id.toString());
    Marker marker = Marker(
      markerId: markerId,
      icon: BitmapDescriptor.defaultMarkerWithHue(isSelected ? _activeMarkerHue : _inactiveMarkerHue),
      position: LatLng(vehicle.latitude, vehicle.longitude),
      onTap: () => _markerTapped(markerId, vehicle),
      consumeTapEvents: true,
    );

    return marker;
  }



  void _markerTapped(MarkerId markerId, Vehicle vehicle) {
    // update currently tapped marker
    _markersById[markerId] = _createMarker(vehicle, isSelected: true, markerId: markerId);
    // reset last tapped marker
    if (_lastTappedMarkerId != null && _lastTappedMarkerId != markerId) {
      _markersById[_lastTappedMarkerId] = _createMarker(_vehicleById[int.parse(_lastTappedMarkerId.value)], isSelected: false, markerId: _lastTappedMarkerId);
    }
    updateMapState(markers: Set.of(_markersById.values), updateMapView: true);
    _lastTappedMarkerId = markerId;

    showVehiclePopup(vehicle: vehicle);
  }


  /// Please specify either [vehicle] or [vehicleId], not both.
  void showVehiclePopup({Vehicle vehicle, int vehicleId}) {
    if (vehicle != null && vehicleId != null) {
      throw ArgumentError("Please specify either vehicle or vehicleId, not both.");
    }
    if (vehicle != null) {
      _vehicleInfoPopupSink.add(vehicle);
      return;
    }
    if (vehicleId != null && vehicleId >= 0) {
      Vehicle vehicle = _vehicleById[vehicleId];
      if (vehicle != null) {
        _vehicleInfoPopupSink.add(vehicle);
        return;
      }
    }
    throw ArgumentError("Something is wrong with your arguments: vehicleId=$vehicleId vs $vehicle");
  }


  Future<void> onResetNorthPressed() async {
    await _mapControllerSubject.value.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        bearing: 0,
        target: _mapStateSubject.value.mapCenter,
        zoom: 14)
    ));
  }


  Future<void> onCenterViewPressed() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    LatLng userLatLng = LatLng(position.latitude, position.longitude);
    updateMapState(mapCenter: userLatLng, updateMapView: false);  // no update: do with animation
    await _mapControllerSubject.value.animateCamera(CameraUpdate.newLatLng(userLatLng));
  }


  bool addMapDetails(MapDetails mapDetails) {
    MapState mapState = _mapStateSubject.value;
    bool added = mapState.addMapDetails(mapDetails);
    updateMapState(updateMapView: true);
    return added;
  }

  bool removeMapDetails(MapDetails mapDetails) {
    bool removed = _mapStateSubject.value.mapDetails.remove(mapDetails);
    _mapStateSubject.add(_mapStateSubject.value);
    return removed;
  }


  void zoomIn() {
    _mapControllerSubject.value.animateCamera(CameraUpdate.zoomIn());
  }

  void zoomOut() {
    _mapControllerSubject.value.animateCamera(CameraUpdate.zoomOut());
  }


  /// callback if the map was clicked without another necessary action
  /// (This will not be called if the user taps on a marker).
  void mapTapped() {
    if (_lastTappedMarkerId != null) {
      _markersById[_lastTappedMarkerId] = _createMarker(_vehicleById[int.parse(_lastTappedMarkerId.value)], isSelected: false, markerId: _lastTappedMarkerId);
      updateMapState(markers: Set.of(_markersById.values), updateMapView: true);
    }
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

    // update map view
    if (updateMapView) {
      _mapStateSubject.add(mapState);
    }
  }


  /// dispose this bloc and release all its resources
  void dispose() {
    _mapControllerSubject.close();
    _mapStateSubject.close();
  }

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
  BIKE_LANES,
  PUBLIC_TRANSPORT,
}