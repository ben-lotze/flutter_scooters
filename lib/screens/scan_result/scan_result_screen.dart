import 'package:circ_flutter_challenge/data/qr_code.dart';
import 'package:circ_flutter_challenge/generic_widgets/drag_slider.dart';
import 'package:flutter/material.dart';

class ScanResultScreen extends StatelessWidget {

  final VehicleQrCode qrCode;

  const ScanResultScreen({Key key, this.qrCode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("Slide to unlock vehicle."),
            SizedBox(height: 16,),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset("assets/icons/qrcode-scan.png", width: 24, height: 24),
                Text(" ID: ${qrCode.id} - ${qrCode.name}"),
              ],
            ),
            SizedBox(height: 16,),
            CustomSlider(),

            // TODO: need to get vehicle from bloc, to show more info and price
          ],
        ),
      ),
    );
  }
}
