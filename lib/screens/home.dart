import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './tabs/createfit.dart';
import './tabs/profile.dart';
import './tabs/recommendPage.dart';

class HomeScreen extends StatelessWidget {

  void _signOut() {
    FirebaseAuth.instance.signOut()
      .then((data) => print('signed out'))
      .catchError((err) => print('${err.message}'));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: _getBackgroundColor(),
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.home, color: _getTextColor(),)),
                Tab(icon: Icon(Icons.create, color: _getTextColor())),
                Tab(icon: Icon(Icons.person, color: _getTextColor())),
              ],
            ),
            title: Center(child: Text('CloutFit', style: TextStyle(color: _getTextColor()))),
            automaticallyImplyLeading: false,
          ),
          body: TabBarView(
            children: [
              RecommendPage(),
              FitCreaterView(),
              ProfileView(),
            ],
          ),
        ),
      );
  }
}

Color _getTextColor(){
  return Color.fromARGB(255, 29, 39, 64);
}

Color _getBackgroundColor(){
  return Color.fromARGB(255, 248, 249, 253);
}
