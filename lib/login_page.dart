import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'auth/auth_gate.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: AuthGate(),
      ),
    );
  }
}
