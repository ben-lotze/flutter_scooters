import 'package:circ_flutter_challenge/blocs/maps_bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapTypeImageButton extends StatelessWidget {

  final String imgAsset;
  final String text;
  final Function onTap;
  final MapType mapType;
  final BuildContext context;

  /// A button with two rows: an image on top and text underneath.
  /// <br>[imgAsset] asset image to be shown
  /// <br>[text] map type name
  /// <br>[onTap] callback
  /// <br>[mapType] mapType associated with this button, necessary to rebuilt its UI based on the associated bloc's map type
  /// <br>[context] parent context, necessary to find bloc(s)
  const MapTypeImageButton({Key key, this.imgAsset, this.text, this.onTap, this.mapType, this.context}) : super(key: key);

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
            return MapTypeImageButtonUi(imgAsset: imgAsset, text: text, drawBorder: drawBorder, onTap: onTap,);
          }
          else {
            return Container(child: Center(child: Text("Loading")));
          }

        }
    );
  }
}




class MapTypeImageButtonUi extends StatelessWidget {

  final String imgAsset;
  final String text;
  final bool drawBorder;
  final Function onTap;

  const MapTypeImageButtonUi({Key key, this.imgAsset, this.text, this.drawBorder, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: <Widget>[
          Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: Image.asset(imgAsset, width: 64, height: 64, fit: BoxFit.cover,),
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                border: drawBorder ? Border.all(width: 3, style: BorderStyle.solid, color: Colors.deepOrange)
                    : Border.all(width: 3, style: BorderStyle.solid, color: Colors.transparent)
            ),
          ),
          Text(text),
        ],
      ),
    );
  }
}
