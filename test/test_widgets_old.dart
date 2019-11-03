import 'package:circ_flutter_challenge/main.dart';
import 'package:circ_flutter_challenge/screens/map_screen/map_type_popup/map_type_image_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

main() {

  group("old tests", () {

    testWidgets('Map screen test', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());

      // check that scanner button exists
      expect(
          find.byWidgetPredicate((Widget widget) {
            return widget is FloatingActionButton && widget.heroTag == 'maps_scanner_button';
          }),
          findsOneWidget
      );






      // tap scanner button
      await tester.tap(find.byWidgetPredicate(
            (Widget widget) => widget is FloatingActionButton && widget.heroTag == 'maps_scanner_button',
//        description: 'widget with tooltip "Back"',
      ));
//    expect(find.text('SCAN'), findsOneWidget);
//    expect(find.text('1'), findsNothing);






      return;
    });


    testWidgets("tap on center-map button works", (tester) async {
      await tester.pumpWidget(MyApp());

      // tap current-location button to center view
      expect(find.byIcon(Icons.my_location), findsOneWidget);
      await tester.tap(find.byIcon(Icons.my_location));

      return;
    });


    testWidgets("tapping zoom buttons", (tester) async {


      await tester.pumpWidget(MyApp());

      await Future.delayed(Duration(seconds: 10), () {});

      // tap zoom buttons
      // TODO: if broken -> inject test controller somehow?
      await tester.tap(find.byIcon(Icons.zoom_in));
//    await tester.tap(find.byIcon(Icons.zoom_out));


      return;
    });





    testWidgets("tap on layers button opens map details popup", (tester) async {
      await tester.pumpWidget(MyApp());

      // Tap the 'layer' button and wait for popup
      await tester.tap(find.byIcon(Icons.layers));
      await tester.pump();
      // check that the popup appears and has the desired content
      expect(find.byWidgetPredicate((Widget widget) => widget is MapTypeImageButton && widget.text == "Normal"), findsOneWidget);
      expect(find.byWidgetPredicate((Widget widget) => widget is MapTypeImageButton && widget.text == "Satellite"), findsOneWidget);
      expect(find.byWidgetPredicate((Widget widget) => widget is MapTypeImageButton && widget.text == "Terrain"), findsOneWidget);

      // TODO: not working
//    expect(find.widgetWithText(MapTypeImageButton, "Normal"), findsOneWidget);
//    expect(find.widgetWithText(MapTypeImageButton, "Satellite"), findsOneWidget);
//    expect(find.widgetWithText(MapTypeImageButton, "Terrain"), findsOneWidget);

      return;
    });

  });



}