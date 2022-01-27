import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'data/ratings.dart';
import 'data/toilet_list_data_source.dart';
import 'icons.dart';

class AddReviewPage extends StatefulWidget {
  const AddReviewPage(this.name, {Key? key}) : super(key: key);
  final String name;
  @override
  _AddReviewPageState createState() => _AddReviewPageState(name);
}

class _AddReviewPageState extends State<AddReviewPage> {
  Rating rating = Rating();
  final String name;
  _AddReviewPageState(this.name) {
    rating.user = FirebaseAuth.instance.currentUser!.email!;
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 1,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: Column(
              children: [
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      "Cleanness:",
                      style: TextStyle(),
                    ),
                    const SizedBox(width: 8),
                    RatingBar.builder(
                      itemBuilder: (context, index) => Icon(
                          MyFlutterApp.toilet_paper,
                          color: Theme.of(context).colorScheme.primary),
                      itemCount: 5,
                      direction: Axis.horizontal,
                      onRatingUpdate: (value) =>
                          {rating.ratingcleanes = value.floor()},
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      "Utilities:",
                      style: TextStyle(),
                    ),
                    const SizedBox(width: 8),
                    RatingBar.builder(
                      itemBuilder: (context, index) => Icon(
                          MyFlutterApp.toilet_paper,
                          color: Theme.of(context).colorScheme.primary),
                      itemCount: 5,
                      direction: Axis.horizontal,
                      onRatingUpdate: (value) =>
                          {rating.ratingutilities = value.floor()},
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      "Atmosphere:",
                      style: TextStyle(),
                    ),
                    const SizedBox(width: 8),
                    RatingBar.builder(
                      itemBuilder: (context, index) => Icon(
                          MyFlutterApp.toilet_paper,
                          color: Theme.of(context).colorScheme.primary),
                      itemCount: 5,
                      direction: Axis.horizontal,
                      onRatingUpdate: (value) =>
                          {rating.ratingatmosphere = value.floor()},
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                TextField(
                  onChanged: (value) => rating.commentBody = value,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Review",
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                ElevatedButton(
                    onPressed: () => {
                          setState(() {
                            ToiletListDataSource(
                                    firestore: FirebaseFirestore.instance)
                                .addRating(name, rating);
                          }),
                        },
                    child: Text("Submit Review"))
              ],
            )),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
