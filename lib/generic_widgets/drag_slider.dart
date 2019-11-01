import 'package:circ_flutter_challenge/screens/map_screen/vehicle_info_popup.dart';
import 'package:flutter/material.dart';


// custom slider for swipe to confirm/abort
class CustomSlider extends StatefulWidget {

  final ValueChanged<double> valueChanged;    // TODO instead of this: offer all sort of callbacks: onRightSideFinished, onLeftSideFinished, onLeftSideReset, onDrag

  CustomSlider({this.valueChanged});

  @override
  CustomSliderState createState() {
    return new CustomSliderState();
  }
}


class CustomSliderState extends State<CustomSlider> {

  ValueNotifier<double> valueListener = ValueNotifier(.0);

  GlobalKey _draggableKey = GlobalKey();
  double _startingXOffset;
//  RenderBox draggableRenderBox;


  @override
  void initState() {
    valueListener.addListener(notifyParent);
    super.initState();
  }

  void notifyParent() {
    if (widget.valueChanged != null) {
      widget.valueChanged(valueListener.value);
    }
  }


  // TODO: check that this ALWAYS happens!
//  @override
//  void didUpdateWidget(CustomSlider oldWidget) {
//    print("didUpdateWidget, ");
//
//    super.didUpdateWidget(oldWidget);
//  }



  @override
  Widget build(BuildContext context) {



    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 2, style: BorderStyle.solid),
        borderRadius: BorderRadius.all(Radius.circular(26)),
        color: Colors.grey
      ),
      height: 52.0,
      padding: EdgeInsets.symmetric(horizontal: 0.0),
      margin: EdgeInsets.all(0.0),

      // need new context for media query
      child: Builder(
        builder: (context) {

          double finishLinePercentage = 0;


          return AnimatedBuilder(
            animation: valueListener,
            builder: (context, child) {
              // TODO: do NOT use align (0.0 - 1.0), but Padding (px) -> no rounding errors
              return Align(
                alignment: Alignment(valueListener.value * 2 - 1, 0.5),   // TODO: must go SLIGHTLY more to the left (start position) -> calculate: border?
                child: child,
              );
            },
            child: GestureDetector(


              onHorizontalDragUpdate: (DragUpdateDetails details) {

                RenderBox draggableRenderBox = _draggableKey.currentContext.findRenderObject();
                if (_startingXOffset == null) {
                  _startingXOffset = draggableRenderBox.localToGlobal(Offset.zero).dx;
                  print("draggable starting offset: $_startingXOffset");
                }
                else {
                  print("draggable starting offset already found: $_startingXOffset");
                }


                // only calculate this once
                if (finishLinePercentage == 0) {
                  print("calculating finishLinePercentage once");
                  finishLinePercentage = (context.size.width - 48 - 4) / context.size.width;    // DO NOT FORGET THE BORDER!!!
                }
                print("finish line percentage: $finishLinePercentage");

                print("\nwidth=${context.size.width}, value=${valueListener.value}, dx=${details.delta.dx}, "
                    "dxGlobal=${details.globalPosition.dx}, dxLocal=${details.localPosition.dx}");


                double dxInDragContainer = draggableRenderBox.localToGlobal(Offset.zero).dx - _startingXOffset;
                print("dxInDragContainer: $dxInDragContainer");

                // update widget position based on swipe/drag position
                valueListener.value = (valueListener.value + details.delta.dx / context.size.width).clamp(.0, 1.0);

                // check position based on real current widget position (widget position is updated less often than finger position)
                print("finish line reached? ${dxInDragContainer / context.size.width}");
                if (dxInDragContainer / context.size.width >= finishLinePercentage) {
                  print("finish line reached!!! ${dxInDragContainer / context.size.width}");
                }
              },
              onHorizontalDragEnd: (DragEndDetails details) {
                // check if inside destination area, otherwise reset to start position
                // TODO: need to store all relevant positions in state
              },
              // draggable child
              // TODO: needs to be stateful too -> needs to track its position to know when it's finished
              child: DraggableCircle(_draggableKey, 48),
            ),
          );
        },
      ),
    );
  }
}