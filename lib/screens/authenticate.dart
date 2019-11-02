import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authenticate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthHandler();
  }
}

class AuthHandler extends StatefulWidget {
  @override
  _AuthHandlerState createState() => _AuthHandlerState();
}

class _AuthHandlerState extends State<AuthHandler> {

  bool loggedIn = false;

  @override
  void initState() {
    FirebaseAuth.instance.currentUser()
      .then(_handleAuth);

    FirebaseAuth.instance.onAuthStateChanged
      .listen(_handleAuth);
    super.initState();
  }

  void _handleAuth(FirebaseUser user) {
    setState(() {
      loggedIn = (user == null);
    });

    if (loggedIn) {
      Navigator.pushNamed(context, '/home');
    } else {
      Navigator.pushNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}