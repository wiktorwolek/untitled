// ignore_for_file: file_names

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled/auth/AddToiletDetails.dart';
import 'package:untitled/geolocation/_determinePosition.dart';

class GoogleMapViewer extends StatefulWidget {
  const GoogleMapViewer({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GoogleMapViewerState();
}

class _GoogleMapViewerState extends State<GoogleMapViewer> {
  final Completer<GoogleMapController> _controller = Completer();
  Future<LatLng> _center = getCurLatLng();

  void onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
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
                  initialCameraPosition: CameraPosition(
                    target: snapshot.data!,
                    zoom: 11.0,
                  ),
                  onTap: (LatLng cord) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddToiletDetails(cord)));
                  },
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
