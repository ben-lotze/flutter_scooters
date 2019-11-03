import 'package:circ_flutter_challenge/blocs/maps_bloc.dart';
import 'package:circ_flutter_challenge/generic_widgets/vertical_image_text_button.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapTypeImageButton extends StatelessWidget {

  final String imgAsset;
  final String text;
  final String tooltip;
  final Function onTap;
  final MapType mapType;
  final BuildContext context;

  static const String TOOLTIP_NORMAL = "Map will show an ordinary normal map";
  static const String TOOLTIP_SATELLITE = "Map will show sattelite images";
  static const String TOOLTIP_TERRAIN = "Map will show a normal map enhanced with some terrain info";


  /// A button with two rows: an image on top and text underneath.
  /// <br>[imgAsset] asset image to be shown
  /// <br>[text] map type name
  /// <br>[tooltip] A tooltip that will appear on long tapping
  /// <br>[onTap] callback
  /// <br>[mapType] mapType associated with this button, necessary to rebuilt its UI based on the associated bloc's map type
  /// <br>[context] parent context, necessary to find bloc(s)
  const MapTypeImageButton({Key key, this.imgAsset, this.text, this.tooltip, this.onTap, this.mapType, this.context}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MapsBloc mapsBloc = Provider.of<MapsBloc>(this.context);
    return StreamBuilder<MapState>(
        stream: mapsBloc.mapStateStream,
        // TODO: initial data?
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Container(child: Center(child: Text("Error")));
          }
          else if(snapshot.hasData) {
            MapType blocMapType = snapshot.data.mapType;
            bool drawBorder = blocMapType == mapType;
            return VerticalImageTextButton(imgAsset: imgAsset, text: text, tooltip: tooltip, drawBorder: drawBorder, onTap: onTap,);
          }
          else {
            return Container(child: Center(child: Text("Loading")));
          }

        }
    );
  }
}




