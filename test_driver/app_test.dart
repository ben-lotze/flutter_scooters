// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';



void main() {

  group("driver tests", () {

    FlutterDriver flutterDriver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {

      // TODO: ANDROID_HOME path needs to be set up, but getting automatic permissions does not work
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
      print("Please grant permission now! You have 15 seconds before the testing starts. Sorry, I found no other way...");
      print("----------------------------------------------------------------------------------------------------------");
      await Future.delayed(Duration(seconds: 15), () {});
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
//    final layerButtonFinder = find.byValueKey("map_layers_button");   // TODO: bug when using key to find widget? see note in MapLayersButton
      final layerButtonFinder = find.byTooltip("Change map layers and settings");
      await flutterDriver.tap(layerButtonFinder);
      await Future.delayed(Duration(seconds: 2), () {});


      // find map types buttons in popup
      final normalViewBtnFinder = find.byTooltip("Map will show an ordinary normal map");
      final satelliteViewBtnFinder = find.byTooltip("Map will show sattelite images");
      final terrainViewBtnFinder = find.byTooltip("Map will show a normal map enhanced with some terrain info");
      // find map details buttons
      final transportBtnFinder = find.byTooltip("Would show public transportation layer (not implemented)");
      final trafficBtnFinder = find.byTooltip("Would show traffic layer (not implemented)");
      final biktBtnFinder = find.byTooltip("Would show layer for bike lanes (not implemented)");



      // press all buttons in the details popup
      await flutterDriver.tap(normalViewBtnFinder);
      await Future.delayed(Duration(seconds: 2), () {});
      await flutterDriver.tap(satelliteViewBtnFinder);
      await Future.delayed(Duration(seconds: 2), () {});
      await flutterDriver.tap(terrainViewBtnFinder);
      await Future.delayed(Duration(seconds: 2), () {});

      // switch on
      await flutterDriver.tap(transportBtnFinder);
      await Future.delayed(Duration(seconds: 1), () {});
      await flutterDriver.tap(trafficBtnFinder);
      await Future.delayed(Duration(seconds: 1), () {});
      await flutterDriver.tap(biktBtnFinder);
      await Future.delayed(Duration(seconds: 1), () {});
      // switch off
      await flutterDriver.tap(transportBtnFinder);
      await Future.delayed(Duration(seconds: 1), () {});
      await flutterDriver.tap(trafficBtnFinder);
      await Future.delayed(Duration(seconds: 1), () {});
      await flutterDriver.tap(biktBtnFinder);
      await Future.delayed(Duration(seconds: 1), () {});

      // TODO: test bloc -> settings changes? bloc needs to be injected

      // close popup, does not work, there is no back button in the UI
//      await flutterDriver.tap(find.pageBack());
    });


  });

}
