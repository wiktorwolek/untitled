import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled/auth/AddToiletDetails.dart';
import 'package:untitled/geolocation/_determinePosition.dart';

import 'ToiletDetailsPage.dart';
import 'ToiletDetails_cubit.dart';
import 'data/toilet.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'dart:ui' as ui;
import 'dart:typed_data';

class GoogleMapToiletList extends StatefulWidget {
  const GoogleMapToiletList(this.toilets, {Key? key}) : super(key: key);
  final List<Toilet> toilets;
  @override
  State<StatefulWidget> createState() => _GoogleMapToiletList();
}

class _GoogleMapToiletList extends State<GoogleMapToiletList> {
  final Completer<GoogleMapController> _controller = Completer();
  BitmapDescriptor? myIcon;
  Future<LatLng> _center = getCurLatLng();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  @override
  void initState() {
    getBytesFromAsset('assets/marker.png', 128).then((onValue) {
      myIcon = BitmapDescriptor.fromBytes(onValue);
    });
  }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);

    for (var toilet in widget.toilets) {
      var marker = Marker(
        markerId: MarkerId(toilet.address),
        position: toilet.coordinates,
        icon: (myIcon != null) ? myIcon! : BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(
          title: toilet.address,
        ),
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                  create: (context) => ToiletDetailsCubit(
                      toiletListDataSource: context.read(),
                      name: toilet.address),
                  child: ToiletDetailsPage(toilet)),
            )),
      );
      setState(() {
        markers[MarkerId((toilet.address))] = marker;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _center,
        builder: (BuildContext context, AsyncSnapshot<LatLng> snapshot) {
          List<Widget> children = [SizedBox()];
          if (snapshot.hasData) {
            children = [
              Container(
                child: Expanded(
                    child: GoogleMap(
                  onMapCreated: onMapCreated,
                  markers: markers.values.toSet(),
                  initialCameraPosition: CameraPosition(
                    target: snapshot.data!,
                    zoom: 11.0,
                  ),
                )),
              ),
            ];
          } else if (snapshot.hasError) {
            children = <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              )
            ];
          } else {
            children = const <Widget>[
              CircularProgressIndicator(),
            ];
          }
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: children,
          ));
        });
  }
}
