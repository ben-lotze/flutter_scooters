import 'package:circ_flutter_challenge/data/verhicle.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:rest_tools/rest_tools_http.dart';


class CircApi {

  static const String _authority = "my-json-server.typicode.com";
  static const String _basePath = "FlashScooters/Challenge";

  final Client _client;

  CircApi({
      Client client
    }) : _client = client != null ? client : Client();

  Future<List<Vehicle>> getVehicles({LatLng position}) async {
//    List<dynamic> jsonVehicles = await RestTools().sendRestRequestForJsonList(_authority, "$_basePath/vehicles");
    List<dynamic> jsonVehicles = await RestToolsHttp(client: _client).getJsonList(_authority, "$_basePath/vehicles");
    return jsonVehicles.map((json) => Vehicle.fromJson(json)).toList();
  }

  Future<Vehicle> getVehicle(int id) async {
//    Map<String, dynamic> jsonMap = await RestTools().sendRestRequestForJson(_authority, "$_basePath/vehicles/$id");
    Map<String, dynamic> jsonMap = await RestToolsHttp(client: _client).getJsonMap(_authority, "$_basePath/vehicles/$id");
    return Vehicle.fromJson(jsonMap);
  }



}