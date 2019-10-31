import 'package:circ_flutter_challenge/data/verhicle.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rest_tools/rest_tools.dart';

class CircApi {

  String authority = "my-json-server.typicode.com";
  String basePath = "FlashScooters/Challenge";


  Future<List<Vehicle>> getVehicles({LatLng position}) async {
    List<dynamic> jsonVehicles = await RestTools.sendRestRequestForJsonList(authority, "$basePath/vehicles");
    return jsonVehicles.map((json) => Vehicle.fromJson(json)).toList();

    // TODO can be done: https://stackoverflow.com/a/53369551
//    return await RestTools.sendRestRequestForList<Vehicle>(authority, "$basePath/vehicles");
  }

  Future<Vehicle> getVehicle(int id) async {
    Map<String, dynamic> jsonMap = await RestTools.sendRestRequestForJson(authority, "$basePath/vehicles/$id");
    return Vehicle.fromJson(jsonMap);
  }



}