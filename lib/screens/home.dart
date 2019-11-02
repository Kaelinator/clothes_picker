import 'package:clothes_picker/screens/auth/authenticate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class HomeScreen extends StatelessWidget {

  void _signOut() {
    FirebaseAuth.instance.signOut()
      .then((data) => print('signed out'))
      .catchError((err) => print('${err.message}'));
  }

  @override
  Widget build(BuildContext context) {
    /* get route arguments */
    final UserArguments args = ModalRoute.of(context).settings.arguments;
    final FirebaseUser user = args.user;

    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            children: <Widget>[
              Text('Welcome, ${user.email}'),
              MaterialButton(
                child: const Text('Sign out'),
                onPressed: _signOut,
              )
            ],
          )
        )
      )
    );
  }
}