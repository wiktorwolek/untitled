import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/auth/AddToiletPage.dart';
import 'package:untitled/data/auth_service.dart';
import 'package:untitled/auth/auth_cubit.dart';
import 'package:untitled/data/toilet_list_data_source.dart';
import 'package:untitled/toiletlist_cubit.dart';

class AuthorizedPage extends StatelessWidget {
  const AuthorizedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(
                flex: 1,
              ),
              ElevatedButton(
                onPressed: () => {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddToiletPage()))
                },
                child: const Text('Add Toilet'),
              ),
              Spacer(
                flex: 1,
              ),
              ElevatedButton(
                onPressed: context.read<AuthService>().signOut,
                child: const Text('Sign out'),
              ),
              Spacer(
                flex: 1,
              )
            ],
          ),
        ],
      ),
    );
  }
}
