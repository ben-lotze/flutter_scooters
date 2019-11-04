import 'package:circ_flutter_challenge/main.dart';
import 'package:circ_flutter_challenge/screens/map_screen/map_type_popup/map_details_image_button.dart';
import 'package:circ_flutter_challenge/screens/map_screen/map_type_popup/map_type_image_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

main() {

  group("widget tests", () {

    testWidgets('Map screen test', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());

      // check that scanner button exists
      expect(find.byWidgetPredicate((Widget widget) => widget is FloatingActionButton && widget.heroTag == 'scanner_button'),
          findsOneWidget);

      // tap scanner button (add mock result from scanner)
      await tester.tap(find.byWidgetPredicate(
            (Widget widget) => widget is FloatingActionButton && widget.heroTag == 'scanner_button',
      ));

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

      expect(find.byWidgetPredicate((Widget widget) => widget is MapDetailsImageButton && widget.text == "Transport"), findsOneWidget);
      expect(find.byWidgetPredicate((Widget widget) => widget is MapDetailsImageButton && widget.text == "Traffic"), findsOneWidget);
      expect(find.byWidgetPredicate((Widget widget) => widget is MapDetailsImageButton && widget.text == "Bike"), findsOneWidget);

      return;
    });

  });


}