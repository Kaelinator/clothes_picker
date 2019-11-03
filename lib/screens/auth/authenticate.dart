import 'package:clothes_picker/screens/auth/signin.dart';
import 'package:clothes_picker/screens/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  FirebaseUser _user;
  bool _isAdmin = false;

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
      _user = user;
      _isAdmin = false;
    });

    if (_user == null) return;

    Firestore.instance.collection('users')
      .document(user.uid)
      .get()
      .then((DocumentSnapshot doc) {
        setState(() {
          _isAdmin = doc.data['isAdmin'];
        });
      })
      .catchError((err) => print('Failed to get user data, ${err.message}'));
  }

  @override
  Widget build(BuildContext context) {
    return _user == null ? SigninScreen() : HomeScreen(_user, _isAdmin);
  }
}