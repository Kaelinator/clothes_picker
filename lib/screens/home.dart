import 'package:clothes_picker/screens/auth/authenticate.dart';
import 'package:clothes_picker/screens/create-article.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './tabs/createfit.dart';
import './tabs/profile.dart';
import './tabs/recommendPage.dart';

class HomeScreen extends StatelessWidget {

  final FirebaseUser _user;
  final bool _isAdmin;
  HomeScreen(this._user, this._isAdmin);

  List<Widget> _buildTabs() {
    List<Widget> tabs = [
      Tab(icon: Icon(Icons.home, color: getTextColor(),)),
      Tab(icon: Icon(Icons.create, color: getTextColor())),
      Tab(icon: Icon(Icons.person, color: getTextColor())),
    ];

    if (_isAdmin)
      tabs.add(Tab(icon: Icon(Icons.add_circle, color: getTextColor())));

    return tabs;
  }

  List<Widget> _buildViews() {
    List<Widget> views = [
      RecommendPage(),
      FitCreaterView(),
      ProfileView(_user),
    ];

    if (_isAdmin)
      views.add(CreateArticleScreen());

    return views;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3 + (_isAdmin ? 1 : 0),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: getBackgroundColor(),
            bottom: TabBar(tabs: _buildTabs()),
            title: Center(child: Text('CloutFit', style: TextStyle(color: getTextColor()))),
            automaticallyImplyLeading: false,
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: _buildViews(),
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
