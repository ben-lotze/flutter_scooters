// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';



void main() {


  // I rely on the fact that Google has its own tests of the Flutter maps plugin, so I do not test
  // that markers appear/disappear when adding/removing them to/from maps controller

  group("driver tests", () {

    FlutterDriver flutterDriver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {

      // TODO: ANDROID_HOME path needs to be set up (add to readme)
      // not working, see https://github.com/flutter/flutter/issues/12561#issuecomment-448999726
//      final Map<String, String> envVars = Platform.environment;
//      String adbPath;
//      if (Platform.isWindows) {
//        adbPath = envVars['ANDROID_HOME'] + '/platform-tools/adb.exe';
//      }
//      else if (Platform.isMacOS) {
//        adbPath = envVars['ANDROID_HOME'] + '/platform-tools/adb';
//      }
//      // grant necessary permissions
//      await Process.run(adbPath , ['shell' ,'pm', 'grant', 'com.example.apppackage', 'android.permission.CAMERA']);
//      await Process.run(adbPath , ['shell' ,'pm', 'grant', 'com.example.apppackage', 'android.permission.ACCESS_FINE_LOCATION']);

      flutterDriver = await FlutterDriver.connect();

      print("----------------------------------------------------------------------------------------------------------");
      print("Please grant permission now! You have 10 seconds before the testing starts. Sorry, I found no other way...");
      print("----------------------------------------------------------------------------------------------------------");
      await Future.delayed(Duration(seconds: 10), () {});
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (flutterDriver != null) {
        flutterDriver.close();
      }
    });



    test("test zoom and center-view buttons", () async {

      final centerViewButtonFinder = find.byTooltip("Center map view to your current position");
      await flutterDriver.tap(centerViewButtonFinder);
      await Future.delayed(Duration(seconds: 3), () {});

      final zoomInButtonFinder = find.byTooltip("Zoom in");
      await flutterDriver.tap(zoomInButtonFinder);
      await Future.delayed(Duration(seconds: 2), () {});

      final zoomOutButtonFinder = find.byTooltip("Zoom out");
      await flutterDriver.tap(zoomOutButtonFinder);
      await Future.delayed(Duration(seconds: 2), () {});
    });


    // keep as last test: there is no UI back button and thus there is no way atm to close the popup
    test("tap on layers button opens map details popup", () async {

      // tap layer button
      // find buttons that need to be tapped
//    final layerButtonFinder = find.byValueKey("map_layers_button");   // TODO: bug when using key to find widget? see note in MapLayersButton
      final layerButtonFinder = find.byTooltip("Change map layers and settings");
      await flutterDriver.tap(layerButtonFinder);
      await Future.delayed(Duration(seconds: 2), () {});


      // find map types buttons
      final normalViewBtnFinder = find.byTooltip("Map will show an ordinary normal map");
      final satelliteViewBtnFinder = find.byTooltip("Map will show sattelite images");
      final terrainViewBtnFinder = find.byTooltip("Map will show a normal map enhanced with some terrain info");
      // find map details buttons
      final trafficBtnFinder = find.byTooltip("Switch traffic on or off");


      // press all buttons in the details popup
      await flutterDriver.tap(normalViewBtnFinder);
      await Future.delayed(Duration(seconds: 2), () {});
      await flutterDriver.tap(satelliteViewBtnFinder);
      await Future.delayed(Duration(seconds: 2), () {});
      await flutterDriver.tap(terrainViewBtnFinder);
      await Future.delayed(Duration(seconds: 2), () {});

      // not yet fully implemented in the bloc/view, so no result to test
      await flutterDriver.tap(trafficBtnFinder);
      await Future.delayed(Duration(seconds: 2), () {});
      await flutterDriver.tap(trafficBtnFinder);
      await Future.delayed(Duration(seconds: 2), () {});

      // TODO: test bloc -> settings changes? bloc needs to be injected


      // close popup, does not work, there is no back button in the UI
//      await flutterDriver.tap(find.pageBack());
    });


  });

}
