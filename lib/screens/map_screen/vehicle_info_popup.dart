import 'package:circ_flutter_challenge/blocs/price_calculator_bloc.dart';
import 'package:circ_flutter_challenge/data/verhicle.dart';
import 'package:circ_flutter_challenge/generic_widgets/drag_slider.dart';
import 'package:circ_flutter_challenge/screens/user_manual/user_manual.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';




/*
  TODO info card

  How to use -> take images from apk

  drag to unlock (full width) --> better name: drag to reserve
  (will be reserved for 15 minutes, after that it's again available for anybody else)

   */
class VehicleInfoPopup extends StatelessWidget {

  final Vehicle vehicle;

  static const double _DRAGGABLE_CIRCLE_SIZE = 48;
  static const double _DRAGGABLE_BAR_BORDER_WIDTH = 2;

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

            CustomSlider(),

            SizedBox(height: 16,),

            // unlock slider
            // TODO: goes into separate class -> adjustable! re-usable
            // TODO: should have lock/unlock icon on destination (destination side changes from left to right)
            // increase size on destination (feedback)
            // - constrain side movements -> how? no further than start/end
            // - when dragging: left of Draggable --> different background color (stronger effect of dragging something "sticky")
            // - move into distinct Widget class, make sizes static const class members
            // - when reaching right destination: switch icon to unlocked lock


            // TODO: this can be much cleaner -> PriceCalculator/PriceFormatter, no blocs?, no new context?
            // TODO: UI should NOT calculate on its own!!!
            // price info
            Provider(
              builder: (context) => PriceCalculatorBloc(),
              child: Builder(
                builder: (context) {
                  PriceCalculatorBloc calculator = PriceCalculatorBloc();

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[

                      Text("Base price: ${calculator.formatPriceInEuro(calculator.basePriceInCents, vehicle.currency)} "
                          "+ ${calculator.formatPriceInEuro(vehicle.price, vehicle.currency)} / ${vehicle.priceTime}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),

                      SizedBox(height: 4,),
                      // TODO: better idea: just one slider with a price + if route calculated: ca. price (different visualization on same slider, with markers?)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(child: Text("5m", style: TextStyle(fontSize: 12),)),
                          Text("${calculator.calculateFormattedPriceForDuration(vehicle.price, vehicle.currency, Duration(minutes: 5))}"),
                          SizedBox(width: 8),
                          CircleAvatar(child: Text("10m", style: TextStyle(fontSize: 12))),
                          Text("${calculator.calculateFormattedPriceForDuration(vehicle.price, vehicle.currency, Duration(minutes: 10))}"),
                          SizedBox(width: 8),
                          CircleAvatar(child: Text("15m", style: TextStyle(fontSize: 12))),
                          Text("${calculator.calculateFormattedPriceForDuration(vehicle.price, vehicle.currency, Duration(minutes: 15))}"),
                        ],
                      ),

//                    Text("5 minutes: ${calculator.calculateFormattedPriceForDuration(vehicle.price, vehicle.currency, Duration(minutes: 5))}\n"
//                    "10 minutes: ${calculator.calculateFormattedPriceForDuration(vehicle.price, vehicle.currency, Duration(minutes: 10))}\n"
//                    "15 minutes: ${calculator.calculateFormattedPriceForDuration(vehicle.price, vehicle.currency, Duration(minutes: 15))}",
//                      style: TextStyle(fontStyle: FontStyle.italic),),
//                        Text(""),
//                        Text(""),

                      //TODO: calculator/dragHandler for X minutes
                    ],
                  );
                },
              ),
            ),




          ],
        ),
      ),
    );

  }
}



