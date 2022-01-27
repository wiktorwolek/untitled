import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:untitled/GoogleMapViewer.dart';
import 'package:untitled/geolocation/_determinePosition.dart';

class AddToiletPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: GoogleMapViewer(),
        ));
  }
}
