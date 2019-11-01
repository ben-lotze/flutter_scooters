import 'package:circ_flutter_challenge/blocs/price_calculator_bloc.dart';
import 'package:circ_flutter_challenge/data/verhicle.dart';
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

            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => TutorialScreen(),
                ))  ;
              },
              child: Text("How do I use Circ E-scooters?", style: TextStyle(color: Colors.orange),)
            ),


            SizedBox(height: 16,),

            // unlock slider
            //TODO: should have lock/unlock icon on destination (destination side changes from left to right)
            // increase size on destination (feedback)
            // - constrain side movements -> how? no further than start/end
            // - when dragging: left of Draggable --> different background color (stronger effect of dragging something "sticky")
            // - move into distinct Widget class, make sizes static const class members
            // - when reaching right destination: switch icon to unlocked lock
            Container(
              width: MediaQuery.of(context).size.width,
              height: _DRAGGABLE_CIRCLE_SIZE + 2 * _DRAGGABLE_BAR_BORDER_WIDTH,
              child: Stack(

                children: <Widget>[

                  // background
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 2),
                    height: _DRAGGABLE_CIRCLE_SIZE + 2 * _DRAGGABLE_BAR_BORDER_WIDTH,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular((_DRAGGABLE_CIRCLE_SIZE + 2 * _DRAGGABLE_BAR_BORDER_WIDTH) / 2),
                        border: Border.all(color: Colors.deepOrange, width: _DRAGGABLE_BAR_BORDER_WIDTH)
                    ),
                  ),

                  Align(
                    alignment: Alignment.center,
                    child: Text("Drag to unlock"),
                  ),

                  // draggable
                  Align(
                    alignment: Alignment.centerLeft,

                    child: Draggable(
                      axis: Axis.horizontal,
                      child: _DraggableCircle(_DRAGGABLE_CIRCLE_SIZE),
                      feedback: _DraggableCircle(_DRAGGABLE_CIRCLE_SIZE),
                      childWhenDragging: Container(height: _DRAGGABLE_CIRCLE_SIZE, width: _DRAGGABLE_CIRCLE_SIZE),
                      maxSimultaneousDrags: 1,
                      data: vehicle.id,
                      onDragCompleted: () {
                        print("Draggable: yay, drag completed");
                        // TODO: keep on right side, switch text
                      },
                    ),
                  ),

                  // target
                  Align(
                    alignment: Alignment.centerRight,
                    child: DragTarget<int>(
                      builder: (context, List<int> candidates, List<dynamic> rejected) {
                        return Container(
                          width: _DRAGGABLE_CIRCLE_SIZE + 2*_DRAGGABLE_BAR_BORDER_WIDTH,
                          height: _DRAGGABLE_CIRCLE_SIZE + 2*_DRAGGABLE_BAR_BORDER_WIDTH,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(color: Colors.deepOrange, width: _DRAGGABLE_BAR_BORDER_WIDTH, style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular((_DRAGGABLE_CIRCLE_SIZE + 2*_DRAGGABLE_BAR_BORDER_WIDTH) / 2),
                          ),
                        );
                      },
                      onWillAccept: (data) {
                        print("DragTarget: dropping would be ok now");
                        return true;
                      },
                      onAccept: (data) {
                        print("DragTarget: drag acceped!!!!!!!!!");
                        // TODO: set bool accepted to true -> must all go into separate widget (can be checked in builder to switch widget after accepting)
                        //  TODO -> maybe create library for this
                      },
                    ),
                  ),

                ],
              ),
            ),

            SizedBox(height: 16,),


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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(child: Text("5m")),
                          Text("${calculator.calculateFormattedPriceForDuration(vehicle.price, vehicle.currency, Duration(minutes: 5))}"),
                          SizedBox(width: 8),
                          CircleAvatar(child: Text("10m")),
                          Text("${calculator.calculateFormattedPriceForDuration(vehicle.price, vehicle.currency, Duration(minutes: 10))}"),
                          SizedBox(width: 8),
                          CircleAvatar(child: Text("15m")),
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



// TODO: use StreamBuilder with info about state (locked + dragging + hovering over destination + accepted/unlocked)
class _DraggableCircle extends StatelessWidget {

  final double _size;

  _DraggableCircle(this._size);

  @override
  Widget build(BuildContext context) {
    return Container(width: _size, height: _size,
      child: Icon(Icons.lock, color: Colors.black),
      margin: EdgeInsets.only(left: 2),   // TODO border size
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular((_size + 4) / 2),    // TODO border size
      ),
    );
  }
}




