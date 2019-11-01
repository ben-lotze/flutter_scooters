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
  Widget backgroundChild = Center(child: Text("Drag to unlock"),);
  Widget backgroundChildWhenDropped = Center(child: Text("Drag to lock"),);




  double borderWidth;
  Color borderColor;

  double containerWidth;
  double containerHeight;


  Function onDrag = () {};
  Function onDraggedDistance = () {};
  Function onDraggedPercentage = () {};
  Function onDragAborted = () {};
  Function onHoveringOverDestination = () {};
  Function onHoveringStoppedWithoutDropping = () {};
  Function onDroppedAtDestination = () {};


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

  double _finishLinePercentage = 0;
  bool _isHoveringOverDestination = false;
  bool _isDroppedOnDestination = false;

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
      child: Stack(
        children: <Widget>[


          // background depends on draggable position
          _isDroppedOnDestination ? widget.backgroundChildWhenDropped : widget.backgroundChild,

//          if(_isDroppedOnDestination) widget.backgroundChildWhenDropped,
//          if(!_isDroppedOnDestination) widget.backgroundChild,

          Builder(
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
//                      print("draggable starting offset: $_startingXOffset");
                    }
//                    else {
//                      print("draggable starting offset already found: $_startingXOffset");
//                    }


                    // only calculate this once
                    if (_finishLinePercentage == 0) {
                      print("calculating finishLinePercentage once");
                      _finishLinePercentage = (context.size.width - 48) / context.size.width;    // DO NOT FORGET THE BORDER!!!
                    }
//                    print("finish line percentage: $_finishLinePercentage");

//                    print("\nwidth=${context.size.width}, value=${_dragPositionPercentageListener.value}, dx=${details.delta.dx}, "
//                        "dxGlobal=${details.globalPosition.dx}, dxLocal=${details.localPosition.dx}");


                    double dxInDragContainer = draggableRenderBox.localToGlobal(Offset.zero).dx - _startingXOffset;
                    _currentDxListener.value = dxInDragContainer;
//                    print("dxInDragContainer: $dxInDragContainer");

                    // update widget position based on swipe/drag position
                    _dragPositionPercentageListener.value = (_dragPositionPercentageListener.value + details.delta.dx / context.size.width).clamp(.0, 1.0);


                    // check position based on real current widget position (widget position is updated less often than finger position)
//                    print("finish line reached? ${dxInDragContainer / context.size.width}");
                    if (dxInDragContainer / context.size.width >= _finishLinePercentage) {
//                      print("finish line reached!!! ${dxInDragContainer / context.size.width}");
                      _isHoveringOverDestination = true;
                    }
                    else {
                      _isHoveringOverDestination = false;
                    }
                  },


                  onHorizontalDragEnd: (DragEndDetails details) {
//                    print("canceled @percentage=${_dragPositionPercentageListener.value}");
                    // check if inside destination area, otherwise reset to start position
                    if (_isHoveringOverDestination) {
                      onDroppedAtDestination();
                    }
                    else {
                      onDragAborted();
                    }
                  },



                  // draggable child
                  child: _isDroppedOnDestination ?
                      DraggableCircle(_draggableKey, 48, Colors.green, Icon(Icons.lock_open, color: Colors.black54))
                      : DraggableCircle(_draggableKey, 48, Colors.deepOrange, Icon(Icons.lock_outline, color: Colors.black54)),
                ),
              );
            },
          )
        ],
      ) ,
    );
  }



  // TODO: offer all these callbacks as Function parameters -> later: for both sides

  /// TODO return current percentage or px offset
  void onDrag() {
    widget.onDrag();
  }

  double onDraggedDistance() {
    return widget.onDraggedDistance();
  }

  double onDraggedPercentage() {
    return widget.onDraggedPercentage();
  }

  /// If drag is not finished into the destination. Specify what should happen additionally to
  /// resetting the draggable to it's starting position.
  void onDragAborted() {
    print("onDragAborted");
    _dragPositionPercentageListener.value = 0.0; // TODO: animation instead of immediate reset
    _isDroppedOnDestination = false;
    // TODO: call callback
    this.setState(() {});
    widget.onDragAborted();
  }

  void onHoveringOverDestination() {
    // inGUI: when hovering too long. tooltip: "Just drop it here to unlock. Trust us." ---> 2nd callback with delay --> start timer whenever entering, stop when leaving

    // TODO: animation! pulsating, glowing/blinking outside
    widget.onHoveringOverDestination();
  }

  void onHoveringStoppedWithoutDropping() {
    widget.onHoveringStoppedWithoutDropping();
  }

  void onDroppedAtDestination() {
    print("onDraggableDroppedAtDestination");
//    _dragPositionPercentageListener.value = finishLinePercentage;
    _isDroppedOnDestination = true;
    this.setState(() {});
    widget.onDroppedAtDestination();
  }


}



/* TODO: for background container
- DraggableCircle needs to be aligned inside a full size container!
- offer default background, with customizable text
 */


class DraggableBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}




// TODO: use StreamBuilder with info about state (locked + dragging + hovering over destination + accepted/unlocked)
class DraggableCircle extends StatelessWidget {

  final GlobalKey _key;

  final double _size;
  final Color backgroundColor;
  final Icon icon;

  DraggableCircle(this._key, this._size, this.backgroundColor, this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _key,
      width: _size,
      height: _size,
      child: icon,
      margin: EdgeInsets.only(left: 0),   // TODO border size
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular((_size + 4) / 2),    // TODO border size
      ),
    );
  }
}


