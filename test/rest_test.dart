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
//    File jsonFile = File("test/vehicles_json_response.json");
//    String content = await jsonFile.readAsString();
//    return Response(content, 200);
//  }
}


main() {


  test("test that the real (ok, also mock) Circ REST endpoint is online and responds", () async {
    CircApi circApi = CircApi();
    List<Vehicle> vehicles = await circApi.getVehicles();
    expect(vehicles.length > 0, true);
  });


  test("test json parsing", () async {
    // mock response content
    final File jsonFile = File("test_resources/vehicles_json_response.json");
    String jsonBody = await jsonFile.readAsString(encoding: utf8);

    // mock response, use utf-8, otherwise mock answer will not work (since API expects utf-8)
    MockClient client1 = MockClient();
    Uri uri = Uri.https("my-json-server.typicode.com", "FlashScooters/Challenge/vehicles", const {});
    Map<String, String> headers = const {
      HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'
    };
    when(client1.get(uri, headers: headers))
        .thenAnswer((_) async => Response(jsonBody, 200, headers: headers));

    // prepare mocked API
    CircApi circApi = CircApi(client: client1);
    // test parsing
    List<Vehicle> vehicles = await circApi.getVehicles();
//    print(vehicles);
    expect(vehicles, isInstanceOf<List<Vehicle>>());
    // check that indeed the mock response is coming in (with different ids than the real REST endpoint)
    for (Vehicle v in vehicles) {
      expect(v.id >= 100 && v.id <= 600, isTrue);
    }
  });



}