import 'package:clothes_picker/screens/auth/authenticate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './tabs/createfit.dart';
import './tabs/profile.dart';
import './tabs/recommendPage.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final UserArguments args = ModalRoute.of(context).settings.arguments;
    final FirebaseUser user = args.user; //email and displayName

    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: getBackgroundColor(),
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.home, color: getTextColor(),)),
                Tab(icon: Icon(Icons.create, color: getTextColor())),
                Tab(icon: Icon(Icons.person, color: getTextColor())),
              ],
            ),
            title: Center(child: Text('CloutFit', style: TextStyle(color: getTextColor()))),
            automaticallyImplyLeading: false,
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
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

Color getTextColor(){
  return Color.fromARGB(255, 29, 39, 64);
}

Color getBackgroundColor(){
  return Color.fromARGB(255, 248, 249, 253);
}
