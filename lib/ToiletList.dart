// ignore_for_file: file_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:untitled/GoogleMapToiletList.dart';
import 'package:untitled/GoogleMapViewer.dart';
import 'package:untitled/AddReviewPage.dart';
import 'package:untitled/ToiletDetails_cubit.dart';
import 'package:untitled/data/toilet.dart';
import 'package:untitled/geolocation/_determinePosition.dart';
import 'package:untitled/icons.dart';
import 'package:untitled/toiletlist_cubit.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'ToiletDetailsPage.dart';
import 'auth/auth_cubit.dart';
import 'data/auth_service.dart';
import 'data/toilet_list_data_source.dart';
import 'login_page.dart';

class ToiletList extends StatelessWidget {
  const ToiletList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => ToiletListDataSource(
        firestore: FirebaseFirestore.instance,
      ),
      child: Provider(
        create: (_) => AuthService(
          firebaseAuth: FirebaseAuth.instance,
        ),
        child: BlocProvider(
          create: (context) => ToiletListCubit(
            toiletListDataSource: context.read(),
          )..refresh(),
          child: BlocProvider(
            create: (ctx) => AuthCubit(
              authService: ctx.read(),
            ),
            child: MaterialApp(
              title: 'ToiletMaps',
              theme: ThemeData(
                primarySwatch: Colors.blue,
                primaryColor: Colors.lightBlue,
              ),
              home: ToiletListPage(),
            ),
          ),
        ),
      ),
    );
  }
}

class ToiletListPage extends StatelessWidget {
  const ToiletListPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('ToiletMaps'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                },
                icon: Icon(Icons.account_box))
          ],
        ),
        body: Column(children: [Expanded(child: const _List())]));
  }
}

class _List extends StatefulWidget {
  const _List({
    Key? key,
  }) : super(key: key);

  @override
  State<_List> createState() => _ListState();
}

class _ListState extends State<_List> {
  late LatLng currpos;
  bool loading = true;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: context.watch<ToiletListCubit>().refresh,
      child: BlocBuilder<ToiletListCubit, ToiletListState>(
        builder: (context, state) {
          if (state is ToiletListLoadedState) {
            getCurLatLng().then((value) => setState(() {
                  currpos = value;
                  loading = false;
                }));

            if (loading || !(state is ToiletListLoadedState))
              return const Center(
                child: CircularProgressIndicator(),
              );
            return GoogleMapToiletList(state.toilets);
            /*
            state.toilets.sort((a, b) =>
                distanceBetwenPoints(a.coordinates, currpos)
                    .compareTo(distanceBetwenPoints(a.coordinates, currpos)));
            return ListView.builder(
              itemCount: state.toilets.length,
              itemBuilder: (_, i) => _Toilet(
                toilet: state.toilets[i],
              ),
            );*/
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class _Toilet extends StatelessWidget {
  _Toilet({
    Key? key,
    required this.toilet,
  }) : super(key: key);
  final Toilet toilet;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
                create: (context) => ToiletDetailsCubit(
                    toiletListDataSource: context.read(), name: toilet.address),
                child: ToiletDetailsPage(toilet)),
          )),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(color: Colors.blueGrey.shade100, boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
          ),
        ]),
        child: Row(
          children: [
            Text(toilet.address),
            RatingBarIndicator(
              rating: toilet.ratings.getAvgRating(),
              itemBuilder: (context, index) => Icon(MyFlutterApp.toilet_paper,
                  color: Theme.of(context).colorScheme.primary),
              itemCount: 5,
              itemSize: 20.0,
              direction: Axis.horizontal,
            ),
          ],
        ),
      ),
    );
  }
}
