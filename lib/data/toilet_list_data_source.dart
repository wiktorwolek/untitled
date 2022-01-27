import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled/data/ratings.dart';
import 'package:untitled/data/toilet.dart';

class ToiletListDataSource {
  const ToiletListDataSource({required FirebaseFirestore firestore})
      : _firestore = firestore;

  final FirebaseFirestore _firestore;

  Future<List<Toilet>> getToilets() async {
    final _toilets =
        await _firestore.collection('Toilets').orderBy('address').get();
    return _toilets.docs.map(Toilet.fromSnapshot).toList();
  }

  Future<Toilet> getToilet(String name) async {
    final toiletdata = await _firestore
        .collection('Toilets')
        .where('address', isEqualTo: name)
        .get();
    var toilet = toiletdata.docs.map(Toilet.fromSnapshot).toList().first;
    var ratings = await _firestore
        .collection('Toilets')
        .doc(toiletdata.docs.first.id)
        .collection('Ratings')
        .get();
    toilet.ratings =
        await new Ratings(ratings.docs.map(Rating.fromSnapshot).toList());
    return toilet;
  }

  Future<void> sendToilet(Toilet toilet) async {
    var referance = await _firestore.collection('Toilets').add(toilet.toMap());
    for (var rating in toilet.ratings.ratings) {
      referance.collection('Ratings').add(rating.toMap());
    }
  }

  Future<void> addRating(String name, Rating rating) async {
    final toiletdata = await _firestore
        .collection('Toilets')
        .where('address', isEqualTo: name)
        .get();
    _firestore
        .collection('Toilets')
        .doc(toiletdata.docs.first.id)
        .collection('Ratings')
        .where('user', isEqualTo: rating.user)
        .get()
        .then((value) {
      if (value.size != 0) return;
      _firestore
          .collection('Toilets')
          .doc(toiletdata.docs.first.id)
          .collection('Ratings')
          .add(rating.toMap());
    });

    return;
  }

  Stream<List<Toilet>> get toiletStream => _firestore
      .collection('Toilets')
      .orderBy('address')
      .snapshots()
      .map((m) => m.docs.map(Toilet.fromSnapshot).toList());
}
