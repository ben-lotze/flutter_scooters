import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:circ_flutter_challenge/blocs/circ_api.dart';
import 'package:circ_flutter_challenge/data/verhicle.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';


class MockClient extends Mock implements Client {
  /// Register a mock response for this mock client.
  /// It will only respond with the String content from the specified [jsonFile] if the [uri] matches exactly, including query parameters.
  /// Automatically uses utf-8 in the header, which should not be replaced, otherwise the mock client will fail to return the response.
  Future<void> registerMockResponse({
    @required Uri uri,
    @required File jsonFile
  }) async {
    String jsonBody = await jsonFile.readAsString(encoding: utf8);
    // use utf-8, otherwise mock answer will not work (since API expects utf-8)
    Map<String, String> headers = const {
      HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'
    };
    when(this.get(uri, headers: headers))
        .thenAnswer((_) async => Response(jsonBody, 200, headers: headers));
  }
}




main() async {

  // prepare mocked API
  MockClient mockClient = MockClient();
  CircApi circApi = CircApi(client: mockClient);


  test("Circ demo REST endpoint is online and responds", () async {
    CircApi circApi = CircApi();
    List<Vehicle> vehicles = await circApi.getVehicles();
    expect(vehicles.length > 0, isTrue);
  });


  test("fetching and json parsing of all vehicles", () async {
    await mockClient.registerMockResponse(
        uri: Uri.https("my-json-server.typicode.com", "FlashScooters/Challenge/vehicles", const {}),
        jsonFile: File("test_resources/response_all_vehicles.json"),
    );

    // test parsing
    List<Vehicle> vehicles = await circApi.getVehicles();
    expect(vehicles, isInstanceOf<List<Vehicle>>());
    // check that indeed the mock response is coming in (with different ids than the real REST endpoint)
    for (Vehicle v in vehicles) {
      expect(v.id >= 100 && v.id <= 600, isTrue);
    }
  });


  test("fetching of one vehicle by id and json parsing", () async {
    await mockClient.registerMockResponse(
        uri: Uri.https("my-json-server.typicode.com", "FlashScooters/Challenge/vehicles/100", const {}),
        jsonFile: File("test_resources/response_vehicle_id_100.json")
    );
    // existing id
    Vehicle vehicle100 = await circApi.getVehicle(100);
    expect(vehicle100, isInstanceOf<Vehicle>());
    expect(vehicle100 != null && vehicle100.id == 100, isTrue);
  });


  test("fetching of one vehicle with invalid JSON response (missing the required id field)", () async {
    await mockClient.registerMockResponse(
        uri: Uri.https("my-json-server.typicode.com", "FlashScooters/Challenge/vehicles/100", const {}),
        jsonFile: File("test_resources/response_vehicle_id_100_missing_id.json")
    );
    expect(() async => await circApi.getVehicle(100),
        throwsA(predicate((e) =>
            e is ArgumentError
            && e.name == "id must not be null"
        )));
  });


  test("fetching of one vehicle by id with one missing non-required field (will be null)", () async {
    await mockClient.registerMockResponse(
        uri: Uri.https("my-json-server.typicode.com", "FlashScooters/Challenge/vehicles/100", const {}),
        jsonFile: File("test_resources/response_vehicle_id_100_missing_battery.json")
    );
    // existing id
    Vehicle vehicle100 = await circApi.getVehicle(100);
    expect(vehicle100, isInstanceOf<Vehicle>());
    expect(vehicle100 != null && vehicle100.id == 100 && vehicle100.batteryLevel == null, isTrue);
  });


  test("fetching non-existing vehicle should throw Exception", () async {
    await mockClient.registerMockResponse(
        uri: Uri.https("my-json-server.typicode.com", "FlashScooters/Challenge/vehicles/6000", const {}),
        jsonFile: File("test_resources/response_empty.json")
    );
    // non-existing id
    expect(() async => await circApi.getVehicle(6000), throwsA(predicate((e) {
//      return e is ArgumentError && e.message == "Invalid vehicle id. Vehicle does not exist.";
      return e is Exception;
    })));
  });



  test("testing http error code", () {
    Uri uri123 = Uri.https("my-json-server.typicode.com", "FlashScooters/Challenge/vehicles/123", const {});
    Map<String, String> headers = const {
      HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'
    };
    when(mockClient.get(uri123, headers: headers))
        .thenAnswer((_) async => Response("", 404, headers: headers));
    expect(() async => await circApi.getVehicle(123), throwsException);
  });

}



