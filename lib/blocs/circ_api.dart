import 'package:circ_flutter_challenge/base/rest_tools.dart';
import 'package:circ_flutter_challenge/data/verhicle.dart';
import 'package:http/http.dart';


class CircApi {

  static const String _authority = "my-json-server.typicode.com";
  static const String _basePath = "FlashScooters/Challenge";

  final Client _client;

  /// defaults to dart's Client, can be replaced with other implementations or mocks
  CircApi({
      Client client
    }) : _client = client != null ? client : Client();



  Future<List<Vehicle>> getVehicles() async {
    List<dynamic> jsonVehicles = await RestToolsHttp(client: _client).getJsonList(_authority, "$_basePath/vehicles");
    return jsonVehicles.map((json) => Vehicle.fromJson(json)).toList();
  }


  /// returns one vehicle with the specified [id]
  Future<Vehicle> getVehicle(int id) async {
    try {
      Map<String, dynamic> jsonMap = await RestToolsHttp(client: _client).getJsonMap(_authority, "$_basePath/vehicles/$id");
      return Vehicle.fromJson(jsonMap);
    }
    on Exception {
      throw ArgumentError("Invalid vehicle id. Vehicle does not exist.");
    }
  }

}