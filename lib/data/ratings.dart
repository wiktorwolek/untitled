import 'package:cloud_firestore/cloud_firestore.dart';

class Ratings {
  List<Rating> ratings;
  Ratings(this.ratings) {}
  add(Rating rating) {
    ratings.add(rating);
  }

  getAvgRating() {
    double avg = 0;
    for (var rating in ratings) {
      avg += rating.getAvgRating();
    }
    return avg;
  }
}

class Rating {
  Rating(
      {this.ratingcleanes = 0,
      this.ratingutilities = 0,
      this.ratingatmosphere = 0,
      this.commentBody = "",
      this.user = ""});
  int ratingcleanes;
  int ratingutilities;
  int ratingatmosphere;
  String commentBody;
  String user;
  getAvgRating() {
    return (ratingcleanes + ratingutilities + ratingatmosphere) / 3;
  }

  static Rating fromSnapshot(
          QueryDocumentSnapshot<Map<String, dynamic>> snapshot) =>
      Rating(
          ratingatmosphere: snapshot.data()['atmosphere'],
          ratingcleanes: snapshot.data()['utilities'],
          ratingutilities: snapshot.data()['cleanes'],
          commentBody: snapshot.data()['body'],
          user: snapshot.data()['user']);

  Map<String, dynamic> toMap() => {
        'atmosphere': ratingatmosphere,
        'utilities': ratingutilities,
        'cleanes': ratingcleanes,
        'user': user,
        'body': commentBody
      };
}
