import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:untitled/AddReviewPage.dart';
import 'package:untitled/data/ratings.dart';
import 'package:untitled/icons.dart';

import 'ToiletDetails_cubit.dart';
import 'data/toilet.dart';
import 'package:url_launcher/url_launcher.dart';

class ToiletDetailsPage extends StatelessWidget {
  Toilet toilet;
  ToiletDetailsPage(this.toilet) {}
  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: new LayoutBuilder(builder:
            (BuildContext context, BoxConstraints viewportConstraints) {
          return ConstrainedBox(
            constraints:
                BoxConstraints(maxHeight: viewportConstraints.maxHeight),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Expanded(
                  child: RefreshIndicator(
                    onRefresh: context.watch<ToiletDetailsCubit>().refresh,
                    child: BlocBuilder<ToiletDetailsCubit, ToiletDetailsState>(
                        builder: (context, state) {
                      if (state is ToiletDetailsLoadedState) {
                        toilet = state.toilets;
                        var canAdd = (FirebaseAuth.instance.currentUser !=
                                    null &&
                                !toilet.ratings.ratings.any((element) =>
                                    element.user ==
                                    FirebaseAuth.instance.currentUser!.email!)
                            ? 1
                            : 0);
                        return Expanded(
                          child: ListView.builder(
                            itemCount: (state.toilets.ratings.ratings.length +
                                canAdd +
                                1),
                            itemBuilder: (_, i) => i == 0
                                ? Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Text(toilet.address,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline4),
                                            Spacer(),
                                            ElevatedButton(
                                                onPressed: () {
                                                  openMap(
                                                      toilet
                                                          .coordinates.latitude,
                                                      toilet.coordinates
                                                          .longitude);
                                                },
                                                child: Text("Navigate to"))
                                          ],
                                        ),
                                      ),
                                      Divider(),
                                      const SizedBox(height: 8),
                                    ],
                                  )
                                : i == 1 && canAdd == 1
                                    ? AddReviewPage(toilet.address)
                                    : _Rating(
                                        state.toilets.ratings
                                            .ratings[i - 1 - canAdd],
                                      ),
                          ),
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
                  ),
                ),
              ),
            ),
          );
        }));
  }
}

class _Rating extends StatelessWidget {
  Rating rating;
  _Rating(this.rating) {}

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                  color: Colors.black, width: 1, style: BorderStyle.solid)),
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
                    RatingBarIndicator(
                      rating: rating.ratingcleanes.toDouble(),
                      itemBuilder: (context, index) => Icon(
                          MyFlutterApp.toilet_paper,
                          color: Theme.of(context).colorScheme.primary),
                      itemCount: 5,
                      direction: Axis.horizontal,
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
                    RatingBarIndicator(
                      rating: rating.ratingutilities.toDouble(),
                      itemBuilder: (context, index) => Icon(
                          MyFlutterApp.toilet_paper,
                          color: Theme.of(context).colorScheme.primary),
                      itemCount: 5,
                      direction: Axis.horizontal,
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
                    RatingBarIndicator(
                      rating: rating.ratingatmosphere.toDouble(),
                      itemBuilder: (context, index) => Icon(
                          MyFlutterApp.toilet_paper,
                          color: Theme.of(context).colorScheme.primary),
                      itemCount: 5,
                      direction: Axis.horizontal,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                TextField(
                    controller: TextEditingController()
                      ..text = rating.commentBody,
                    decoration:
                        new InputDecoration(border: OutlineInputBorder()),
                    enabled: false,
                    maxLines: null),
                const SizedBox(
                  height: 8,
                ),
              ],
            )),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
