import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/auth/auth_cubit.dart';
import 'package:untitled/auth/authorized_page.dart';
import 'package:untitled/auth/unauthorized_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return state is SignedInState ? AuthorizedPage() : UnauthorizedPage();
      },
    );
  }
}

class AuthPage extends StatelessWidget {
  AuthPage(this.child, {Key? key}) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return child;
      },
    );
  }
}
