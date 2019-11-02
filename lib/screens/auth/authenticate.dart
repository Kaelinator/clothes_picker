import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserArguments {
  final FirebaseUser user;

  UserArguments(this.user);
}

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

  FirebaseUser user;

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
      this.user = user;
    });

    if (user == null) {
      Navigator.pushNamed(context, '/signin');
    } else {
      Navigator.pushNamed(context, '/home', arguments: UserArguments(user));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}