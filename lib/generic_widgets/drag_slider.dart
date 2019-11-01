import 'package:circ_flutter_challenge/screens/map_screen/vehicle_info_popup.dart';
import 'package:flutter/material.dart';


// custom slider for swipe to confirm/abort
class CustomSlider extends StatefulWidget {

  // TODO: set all attributes to final (once class is finished)

  Widget draggable;
  Widget draggableWhenDroppedOnDestination;
  // TODO: maybe add draggableWhenHoveringOverDestination

  Color backgroundColor;
  // TODO: background container should be a Widget! (with any child and Text and whatever) -> fallback to my default
  Widget backgroundChild;
  Widget backgroundChildWhenDropped;


  double borderWidth;
  Color borderColor;

  double containerWidth;
  double containerHeight;


//  final ValueChanged<double> valueChanged;    // TODO instead of this: offer all sort of callbacks: onRightSideFinished, onLeftSideFinished, onLeftSideReset, onDrag
//  CustomSlider({this.valueChanged});

  @override
  CustomSliderState createState() {
    return new CustomSliderState();
  }
}


// TODO: try if this also works inside stateless widget (I never use setState)
class CustomSliderState extends State<CustomSlider> {

  /// Animation is triggered by this listenable:
  /// Current position of the draggable inside the container where it can be dragged around.
  /// <br>Percentage at start position is 0.
  /// <br>Percentage at destination position is NOT 1: It's 1 - (draggable size / complete container size).
  ValueNotifier<double> _dragPositionPercentageListener = ValueNotifier(0.0);
  ValueNotifier<double> _currentDxListener = ValueNotifier(0.0);


  /// key to access draggable render object (key is put into draggable widget).
  /// Necessary to calculate current position on screen.
  GlobalKey _draggableKey = GlobalKey();
  double _startingXOffset;

  double finishLinePercentage = 0;
  bool _draggableInFinishArea = false;

  // StartingSide -> left or ride --> can/will be switched once the destination is reached



  @override
  void initState() {
//    valueListener.addListener(notifyParent);
    super.initState();
  }

//  void notifyParent() {
//    if (widget.valueChanged != null) {
//      widget.valueChanged(valueListener.value);
//    }
//  }


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
        color: Colors.grey,
      ),
      height: 52.0,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 0.0),
      margin: EdgeInsets.all(0.0),

      // new context necessary
      child: Builder(
        builder: (context) {


          return AnimatedBuilder(
            animation: _dragPositionPercentageListener,  // TODO: find out why animation does not work based on padding/px instead of [0,1] alignment
//            animation: internalDxListener,
            builder: (context, child) {
              return Align(
                alignment: Alignment(_dragPositionPercentageListener.value * 2 - 1, 0.5),
                child: child,
              );

//              return Padding(
//                padding: EdgeInsets.only(left: internalDxListener.value ?? 0),
//                child: child,
//              );

            },

            // visible background
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
                  finishLinePercentage = (context.size.width - 48) / context.size.width;    // DO NOT FORGET THE BORDER!!!
                }
                print("finish line percentage: $finishLinePercentage");

                print("\nwidth=${context.size.width}, value=${_dragPositionPercentageListener.value}, dx=${details.delta.dx}, "
                    "dxGlobal=${details.globalPosition.dx}, dxLocal=${details.localPosition.dx}");


                double dxInDragContainer = draggableRenderBox.localToGlobal(Offset.zero).dx - _startingXOffset;
                _currentDxListener.value = dxInDragContainer;
                print("dxInDragContainer: $dxInDragContainer");

                // update widget position based on swipe/drag position
                _dragPositionPercentageListener.value = (_dragPositionPercentageListener.value + details.delta.dx / context.size.width).clamp(.0, 1.0);


                // check position based on real current widget position (widget position is updated less often than finger position)
                print("finish line reached? ${dxInDragContainer / context.size.width}");
                if (dxInDragContainer / context.size.width >= finishLinePercentage) {
                  print("finish line reached!!! ${dxInDragContainer / context.size.width}");
                  _draggableInFinishArea = true;
                }
                else {
                  _draggableInFinishArea = false;
                }
              },


              onHorizontalDragEnd: (DragEndDetails details) {
                print("canceled @percentage=${_dragPositionPercentageListener.value}");
                // check if inside destination area, otherwise reset to start position
                if (_draggableInFinishArea) {
                  // TODO: offer callback
                  onDraggableDroppedAtDestination();
                }
                else {
                  onDragAborted();
                }
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



  // TODO: offer all these callbacks as Function parameters -> later: for both sides

  /// TODO return current percentage or px offset
  double onDrag() {

  }


  /// If drag is not finished into the destination. Specify what should happen additionally to
  /// resetting the draggable to it's starting position.
  void onDragAborted() {
    print("onDragAborted");
    _dragPositionPercentageListener.value = 0.0; // TODO: animation instead of immediate reset
    // TODO: call callback
  }

  void onHoveringOverDestination() {
    // when hovering too long. tooltip: "Just drop it here to unlock. Trust us."

    // TODO: animation! pulsating, glowing/blinking outside
  }

  void onDraggableDroppedAtDestination() {
    print("onDraggableDroppedAtDestination");
//    _dragPositionPercentagListener.value = finishLinePercentage;
  }


}