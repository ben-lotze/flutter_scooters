import 'package:circ_flutter_challenge/base/formatters.dart';
import 'package:circ_flutter_challenge/data/verhicle.dart';
import 'package:circ_flutter_challenge/generic_widgets/drag_slider.dart';
import 'package:circ_flutter_challenge/screens/user_manual/user_manual.dart';
import 'package:flutter/material.dart';



class VehicleInfoPopup extends StatelessWidget {

  final Vehicle vehicle;

  VehicleInfoPopup(this.vehicle);

  @override
  Widget build(BuildContext context) {

    return Card(
      margin: EdgeInsets.only(left: 16, right: 16),
      color: Colors.white,
      elevation: 16,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(8))),
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[

            // id / battery
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset("assets/icons/qrcode-scan.png", width: 24, height: 24),
                Text(" ID: ${vehicle.id}"),
                SizedBox(width: 16,),
                Icon(Icons.battery_std),
                Text(" ${vehicle.batteryLevel}%"),
              ],
            ),

            SizedBox(height: 8),

            // tutorial
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => TutorialScreen(),
                ))  ;
              },
              child: Text("How do I use Circ E-scooters?", style: TextStyle(color: Colors.orange),)
            ),


            SizedBox(height: 16,),

            DragToConfirmSlider(),

            SizedBox(height: 16,),

            // price info
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                Text("Base price: ${PriceFormatter.formatPrice(PriceFormatter.BASE_PRICE_CENTS, vehicle.currency)} "
                    "+ ${PriceFormatter.formatPrice(vehicle.price, vehicle.currency)} "
                    "/ ${TimeFormatter.formatTime(vehicle.priceTime)}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),

                // some example prices
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("5': ${PriceFormatter.formatPriceForDuration(vehicle.price, vehicle.currency, Duration(minutes: 5))}"),
                    SizedBox(width: 16),
                    Text("10': ${PriceFormatter.formatPriceForDuration(vehicle.price, vehicle.currency, Duration(minutes: 10))}"),
                    SizedBox(width: 16),
                    Text("15': ${PriceFormatter.formatPriceForDuration(vehicle.price, vehicle.currency, Duration(minutes: 15))}"),
                  ],
                ),

              ],
            ),

          ],
        ),
      ),
    );

  }
}



