import 'package:circ_flutter_challenge/screens/map_screen/map_screen.dart';
import 'package:flutter/material.dart';

void main() {
  // fixes randomly appearing error "Overflow on channel: flutter/lifecycle. Messages on this channel are being discarded in FIFO fashion."
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Circ Flutter Challenge',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange, // TODO: use real Circ color(s)
      ),
      home: Scaffold(body: MapScreen())
    );
  }
}