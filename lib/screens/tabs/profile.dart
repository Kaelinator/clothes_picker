import 'package:flutter/material.dart';
import 'package:clothes_picker/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileView extends StatelessWidget {
  final String _fullName = "Randy Kirk";
  final String _bio =
      "\"Hi, I am a Freelance developer working for hourly basis. If you wants to contact me to build your product leave a message.\"";
  final String _followers = "173";
  final String _customfits = "11";
  final String _likes = "450";

  
  void _signOut() {
    FirebaseAuth.instance.signOut()
      .then((data) => print('signed out'))
      .catchError((err) => print('${err.message}'));
  }

  Widget _buildCoverImage(Size screenSize) {
    return Container(
      height: screenSize.height / 2.6,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/profile_bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: <Widget>[
          SizedBox(height: 50),
          _profileImage(),
          Text(
            _fullName,
            style: getTextStyle(),
          )
        ],
      )
    );
  }

  Widget _profileImage() {
    return Center(
      child: InkWell(
        onTap: () => print("change profile image"),
        child: new Container(
          width: 140,
          height: 140,
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            image: DecorationImage(
              image:  NetworkImage("https://s.hdnux.com/photos/52/31/41/11114611/5/920x920.jpg"),
              fit: BoxFit.cover,
            ),
            shape: BoxShape.circle,
            color: getBackgroundColor(),
          ),
        ),
      ),
    );
  }


  Widget _buildStatItem(String label, String count) {

    TextStyle _statCountTextStyle = TextStyle(
      color: Colors.black54,
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          count,
          style: _statCountTextStyle,
        ),
        Text(
          label,
          style: getTextStyle(),
        ),
      ],
    );
  }

  Widget _buildStatContainer() {
    return Container(
      height: 65.0,
      margin: EdgeInsets.only(top: 10, bottom: 2),
      decoration: BoxDecoration(
        color: Color(0xFFEFF4F7),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildStatItem("Followers", _followers),
          _buildStatItem("Fits", _customfits),
          _buildStatItem("Likes", _likes),
        ],
      ),
    );
  }


  Widget _buildSeparator(Size screenSize) {
    return Container(
      width: screenSize.width,
      height: 2.0,
      color: getTextColor(),
    );
  }

  Widget _buildButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: _signOut,
              child: Container(
                height: 40.0,
                decoration: BoxDecoration(
                  border: Border.all(),
                  color: Color(0xFF404A5C),
                ),
                child: Center(
                  child: Text(
                    "Sign Out",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _buildCoverImage(screenSize),
                  _buildStatContainer(),
                  _buildSeparator(screenSize),
                  SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Wardrobe", style: getTextStyle()),
                      InkWell(
                        onTap: () => print("add article"),
                        child: Icon(Icons.add_circle),
                      ),    
                    ],
                  ),
                  SizedBox(height: 4.0),
                  SizedBox(height: 8.0),
                  _buildButtons(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


 TextStyle getTextStyle(){
   TextStyle _nameTextStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.black,
      fontSize: 28.0,
      fontWeight: FontWeight.w700,
    );

    return _nameTextStyle;
 }