import 'package:flutter/material.dart';


/// <b>WORK IN PROGRESS</b>
/// <br>Will be published as a package soon.
/// <br>Customizable swipe slider to implement things like swipe to confirm/abort.
/// Can trigger all sorts of callbacks at specified events.
class DragToConfirmSlider extends StatefulWidget {

  // TODO: set all attributes to final (once class is finished)
  // TODO: width and height of both draggables as additional params --> calculations are based of them -> alternative: measure/read once
  // TODO: offer customizable sizes
  // TODO: fix: draggable should be always directly under the finger (distance grows the more the destination is reached)

  final Widget draggable = DraggableCircle(48, Colors.red, Icon(Icons.lock_outline, color: Colors.black54));
  final Widget draggableWhenDroppedOnDestination = DraggableCircle(48, Colors.green, Icon(Icons.lock_open, color: Colors.black54));
  // TODO: maybe add draggableWhenHoveringOverDestination


//  Color backgroundColor;    // different colors per side
  // TODO: background container should be a Widget! (with any child and Text and whatever) -> fallback to default
  Widget backgroundChild = Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(24)),
      color: Colors.orange,
    ),
    child: Center(child: Text("Drag to unlock"),)
  );

  Widget backgroundChildWhenDropped = Center(child: Text("Drag to lock"),);

  /// specify a trail that will be following the draggable
  Color trailColor; // or trailWidget(s)? possibly multiple, depending on percentage + customizable morphing effect/animation


  // from 0-100
  // int snapPercentage;  TODO: add snapPercentage parameter (int [0,100] or double [0, 1])

  // StartingSide -> left or ride --> can/will be switched once the destination is reached

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


  @override
  DragToConfirmSliderState createState() {
    return new DragToConfirmSliderState();
  }
}




// TODO: try if this also works inside stateless widget (I never use setState)
class DragToConfirmSliderState extends State<DragToConfirmSlider> {

  /// Animation is triggered by this listenable:
  /// Current position of the draggable inside the container where it can be dragged around.
  /// <br>Percentage at start position is 0.
  /// <br>Percentage at destination position is NOT 1: It's 1 - (draggable size / complete container size).
  ValueNotifier<double> _dragPositionPercentageListener = ValueNotifier(0.0);
  ValueNotifier<double> _currentDxListener = ValueNotifier(0.0);


  /// key to access draggable render object (key is put into draggable widget).
  final GlobalKey _draggableKey = GlobalKey();

  /// Necessary to calculate current position on screen.
  double _startingXOffset;

  double _measuredContainerWidth;

  double _dragDestinationPercentage = 0;
  bool _isHoveringOverDestination = false;
//  bool _isDroppedOnDestination = false;

  DraggableHomeSide _draggableHomeSide = DraggableHomeSide.LEFT;


  @override
  Widget build(BuildContext context) {
    // part of the background
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 2, style: BorderStyle.solid),
        borderRadius: BorderRadius.all(Radius.circular(26)),
        color: Colors.grey,
      ),
      height: 52.0,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 0.0),
      margin: EdgeInsets.symmetric(horizontal: 32),

      // new context necessary
      child: Stack(
        children: <Widget>[

          // background depends on draggable home position
          _draggableHomeSide == DraggableHomeSide.LEFT ? widget.backgroundChild : widget.backgroundChildWhenDropped,

          // trail while dragging
          Builder(
            builder: (context) {
              return AnimatedBuilder(
                animation: _dragPositionPercentageListener,
                builder: (context, child) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 0, style: BorderStyle.none),
                        borderRadius: BorderRadius.horizontal(
                            left: _draggableHomeSide == DraggableHomeSide.LEFT ? Radius.circular(24) : Radius.zero,
                            right: _draggableHomeSide == DraggableHomeSide.LEFT ? Radius.zero : Radius.circular(24),
                        ),
                        color: _draggableHomeSide == DraggableHomeSide.LEFT ? Colors.green : Colors.orange,
                      ),
                      height: 48,
                      width: _draggableHomeSide == DraggableHomeSide.LEFT ? _currentDxListener.value + 24 : _measuredContainerWidth - _currentDxListener.value,
                      margin: EdgeInsets.only(left: _draggableHomeSide == DraggableHomeSide.LEFT ? 0 : _currentDxListener.value + 24)
                    ),
                  );
                },
              );
            },
          ),



          // draggable
          Builder(
            builder: (context) {
              return AnimatedBuilder(
                animation: _dragPositionPercentageListener,
//            animation: internalDxListener,    // TODO: find out why animation does not work based on padding/px instead of [0,1] alignment (easier to calculate)
                builder: (context, child) {
                  return Align(
                    alignment: Alignment(_dragPositionPercentageListener.value * 2 - 1, 0.5),
                    child: child,
                  );
//              return Padding(
//                padding: EdgeInsets.only(left: _currentDxListener.value ?? 0),
//                child: child,
//              );
                },


                child: GestureDetector(

                  onHorizontalDragUpdate: (DragUpdateDetails details) {
                    _measuredContainerWidth = context.size.width;

                    RenderBox draggableRenderBox = _draggableKey.currentContext.findRenderObject();
                    if (_startingXOffset == null) {
                      _startingXOffset = draggableRenderBox.localToGlobal(Offset.zero).dx;
//                      print("draggable starting offset: $_startingXOffset");
                    }
//                    else {
//                      print("draggable starting offset already found: $_startingXOffset");
//                    }


                    // only calculate this once
                    if (_dragDestinationPercentage == 0) {
//                      print("calculating finishLinePercentage once");
                      _dragDestinationPercentage = (context.size.width - 48) / context.size.width;
                    }
//                    print("dragDestinationPercentage: $_dragDestinationPercentage");
//                    print("\nwidth=${context.size.width}, startOffset=$_startingXOffset, value=${_dragPositionPercentageListener.value}, dx=${details.delta.dx}, "
//                        "dxGlobal=${details.globalPosition.dx}, dxLocal=${details.localPosition.dx}, home=$_draggableHomeSide");


                    double dxInDragContainer = draggableRenderBox.localToGlobal(Offset.zero).dx - _startingXOffset;
                    _currentDxListener.value = dxInDragContainer;
//                    print("dxInDragContainer: $dxInDragContainer");

                    // update widget position based on swipe/drag position
                    _dragPositionPercentageListener.value = (_dragPositionPercentageListener.value + details.delta.dx / context.size.width).clamp(.0, 1.0);


                    // check position based on real current widget position (widget position is updated less often than finger position)
//                    print("finish line reached? ${dxInDragContainer / context.size.width}");
                    if (_draggableHomeSide == DraggableHomeSide.LEFT) {
                      if (dxInDragContainer / context.size.width >= _dragDestinationPercentage) {
//                        print("dest=right -> finish line reached!!! ${dxInDragContainer / context.size.width}");
                        _isHoveringOverDestination = true;
                      }
                      else {
                        _isHoveringOverDestination = false;
                      }
                    }
                    // draggable home = right side
                    else {
                      if (dxInDragContainer / context.size.width == 0) {
//                        print("dest=left -> finish line reached!!! ${dxInDragContainer / context.size.width}");
                        _isHoveringOverDestination = true;
                      }
                      else {
                        _isHoveringOverDestination = false;
                      }
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



                  // the actual draggable
                  child: KeyedSubtree(
                      key: _draggableKey,
                      child: _draggableHomeSide == DraggableHomeSide.LEFT ? widget.draggable : widget.draggableWhenDroppedOnDestination,
                  ),

                ),
              );
            },
          )
        ],
      ) ,
    );
  }


  // TODO: offer all these callbacks for both sides !!!!!!!!!! -> caller does not know!

  /// TODO return current percentage or px offset
  void onDrag() {
    widget.onDrag();  // user callback
  }

  double onDraggedDistance() {
    return widget.onDraggedDistance();  // user callback
  }

  double onDraggedPercentage() {
    return widget.onDraggedPercentage();  // user callback
  }

  /// If drag is not finished into the destination. Specify what should happen additionally to
  /// resetting the draggable to it's starting position.
  void onDragAborted() {
    print("onDragAborted start: Home=$_draggableHomeSide");
    // TODO: animation instead of immediate reset

    this.setState(() {
//      _currentDxListener.value = (_draggableHomeSide == DraggableHome.LEFT) ? 0.0 : 311.42857142857144;   // TODO: use width + align tail on right side!
      _currentDxListener.value = (_draggableHomeSide == DraggableHomeSide.LEFT) ? 0.0 : _measuredContainerWidth;   // TODO: use width + align tail on right side!
      _dragPositionPercentageListener.value = (_draggableHomeSide == DraggableHomeSide.LEFT) ? 0.0 : _dragDestinationPercentage + (48 / _measuredContainerWidth);
    });
    widget.onDragAborted(); // user callback
    print("onDragAborted end: Home=$_draggableHomeSide");
  }

  void onHoveringOverDestination() {
    // inGUI: when hovering too long. tooltip: "Just drop it here to unlock. Trust us." ---> 2nd callback with delay --> start timer whenever entering, stop when leaving

    // TODO: animation! pulsating, glowing/blinking outside
    widget.onHoveringOverDestination(); // user callback
  }

  // TODO: THIS METHOD IS STUPID --> IMPOSSIBLE STATE!
  /// may be used to trigger different action (when aborting while hovering) than earlier aborting
  void onHoveringAbortedWithoutDropping() {
    widget.onHoveringStoppedWithoutDropping();  // user callback
  }

  void onDroppedAtDestination() {
//    print("onDraggableDroppedAtDestination start: Home=$_draggableHomeSide");
    this.setState(() {
      _dragPositionPercentageListener.value = _draggableHomeSide == DraggableHomeSide.LEFT ? _dragDestinationPercentage + (48 / _measuredContainerWidth) : 0.0;
//      _isDroppedOnDestination = false;
      _draggableHomeSide = _draggableHomeSide == DraggableHomeSide.LEFT ? DraggableHomeSide.RIGHT : DraggableHomeSide.LEFT;
    });
    widget.onDroppedAtDestination();  // user callback
//    print("onDraggableDroppedAtDestination end: Home=$_draggableHomeSide");
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

//  GlobalKey key;

  final double _size;     // TODO size can be taken from height/border settings
  final Color backgroundColor;
  final Icon icon;

  DraggableCircle(this._size, this.backgroundColor, this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
//      key: key,
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



/// Specifies the home side of the draggable: it falls back to this side if dropped early.
enum DraggableHomeSide {
  LEFT,
  RIGHT,
}
