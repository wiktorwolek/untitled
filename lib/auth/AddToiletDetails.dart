import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled/ToiletList.dart';
import 'package:untitled/data/ratings.dart';
import 'package:untitled/data/toilet.dart';
import 'package:untitled/data/toilet_list_data_source.dart';

import '../icons.dart';

class AddToiletDetails extends StatelessWidget {
  final LatLng position;
  AddToiletDetails(this.position);
  final NameController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: new AppBar(),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                  decoration: const InputDecoration(hintText: "Name"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name should not be empty';
                    }
                    return null;
                  },
                  controller: NameController),
              const SizedBox(height: 8),
              ElevatedButton(
                  onPressed: () => {
                        if (_formKey.currentState!.validate())
                          {
                            ToiletListDataSource(
                                    firestore: FirebaseFirestore.instance)
                                .sendToilet(Toilet(
                                    NameController.text,
                                    position,
                                    Ratings(List.empty(growable: true)))),
                            Navigator.popUntil(
                                context, (route) => !Navigator.canPop(context))
                          }
                      },
                  child: Text("Add Toilet"))
            ],
          ),
        ),
      ),
    );
  }
}
