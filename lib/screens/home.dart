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
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            children: <Widget>[
              const Text('Welcome'),
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