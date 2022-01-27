import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled/data/ratings.dart';

class Toilet {
  Toilet(this.address, this.coordinates, this.ratings) {}

  late Ratings ratings;
  final String address;
  final LatLng coordinates;

  static Toilet fromSnapshot(
          QueryDocumentSnapshot<Map<String, dynamic>> snapshot) =>
      Toilet(
          snapshot.data()['address'],
          LatLng(snapshot.data()['latitude'], snapshot.data()['longitude']),
          Ratings(List.empty(growable: true)));

  Map<String, dynamic> toMap() => {
        'address': address,
        'latitude': coordinates.latitude,
        'longitude': coordinates.longitude,
      };
}
