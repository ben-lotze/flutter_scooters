import 'dart:convert';

import 'package:circ_flutter_challenge/blocs/circ_api.dart';
import 'package:circ_flutter_challenge/data/verhicle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:rest_tools/rest_tools.dart';


//import 'package:sky_engine/_http/http.dart' as http;
import 'package:http/http.dart';


import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:mockito/mockito.dart';


class MockClient extends Mock implements Client {

//  @override
//  Future<Response> get(url, {Map<String, String> headers}) async {
//    File jsonFile = File("test/response_all_vehicles.json");
//    String content = await jsonFile.readAsString();
//    return Response(content, 200);
//  }
}


main() async {

  // prepare mocked API
  MockClient mockClient = MockClient();
  CircApi circApi = CircApi(client: mockClient);


  test("test that the Circ demo REST endpoint is online and responds", () async {
    CircApi circApi = CircApi();
    List<Vehicle> vehicles = await circApi.getVehicles();
    expect(vehicles.length > 0, isTrue);
  });


  test("test fetching and json parsing of all vehicles", () async {
    await registerMockResponse(
        client: mockClient,
        uri: Uri.https("my-json-server.typicode.com", "FlashScooters/Challenge/vehicles", const {}),
        jsonFile: File("test_resources/response_all_vehicles.json"),
    );

    // test parsing
    List<Vehicle> vehicles = await circApi.getVehicles();
//    print(vehicles);
    expect(vehicles, isInstanceOf<List<Vehicle>>());
    // check that indeed the mock response is coming in (with different ids than the real REST endpoint)
    for (Vehicle v in vehicles) {
      expect(v.id >= 100 && v.id <= 600, isTrue);
    }
  });


  test("test fetching of one vehicle by id and json parsing", () async {
    await registerMockResponse(
        client: mockClient,
        uri: Uri.https("my-json-server.typicode.com", "FlashScooters/Challenge/vehicles/100", const {}),
        jsonFile: File("test_resources/response_vehicle_id_100.json")
    );
    // existing id
    Vehicle vehicle100 = await circApi.getVehicle(100);
    expect(vehicle100 != null && vehicle100.id == 100, isTrue);
  });


  test("test fetching non-existing vehicle", () async {
    await registerMockResponse(
        client: mockClient,
        uri: Uri.https("my-json-server.typicode.com", "FlashScooters/Challenge/vehicles/6000", const {}),
        jsonFile: File("test_resources/response_empty.json")
    );
    // non-existing id
    expect(() async => await circApi.getVehicle(6000),
        throwsA(predicate((e) =>
                e is ArgumentError
                && e.message == "Invalid vehicle id. Vehicle does not exist.")
        ));
  });

}


/// Register a mock response for the specified [client].
/// It will only respond with the String content from the specified [jsonFile] if the [uri] matches exactly, including query parameters.
/// Automatically uses utf-8 in the header, which should not be replaced, otherwise the mock client will fail to return the response.
Future<void> registerMockResponse({
    @required MockClient client,
    @required Uri uri,
    @required File jsonFile
    }) async {
  String jsonBody = await jsonFile.readAsString(encoding: utf8);
  // use utf-8, otherwise mock answer will not work (since API expects utf-8)
  Map<String, String> headers = const {
    HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'
  };
  when(client.get(uri, headers: headers))
      .thenAnswer((_) async => Response(jsonBody, 200, headers: headers));
}