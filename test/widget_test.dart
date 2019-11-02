// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:circ_flutter_challenge/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  TestWidgetsFlutterBinding.ensureInitialized();

  // I rely on the fact that Google has its own tests of the Flutter maps plugin, so I do not test
  // that markers appear/disappear when adding/removing them to/from maps controller


  testWidgets('Map screen test', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    // check that scanner button exists
    expect(
        find.byWidgetPredicate((Widget widget) {
          return widget is FloatingActionButton
              && widget.heroTag == 'maps_scanner_button';
        }),
        findsOneWidget
    );


    // check current-location button
    await tester.tap(find.byIcon(Icons.my_location));

    // check zoom buttons
    // TODO: if broken -> inject test controller somehow?
    await tester.tap(find.byIcon(Icons.zoom_in));
    await tester.tap(find.byIcon(Icons.zoom_out));

    // tap scanner button
    await tester.tap(find.byWidgetPredicate(
        (Widget widget) => widget is FloatingActionButton && widget.heroTag == 'maps_scanner_button',
//        description: 'widget with tooltip "Back"',
    ));
//    expect(find.text('SCAN'), findsOneWidget);
//    expect(find.text('1'), findsNothing);



    // Tap the 'layer' button and wait for popup
    await tester.tap(find.byIcon(Icons.layers));
    await tester.pump();

    // check that the popup appears and has the desired content
    expect(find.text('Default'), findsOneWidget);
    expect(find.text('Satelite'), findsOneWidget);


  });

}
