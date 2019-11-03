import 'dart:io';

import 'package:clothes_picker/screens/auth/authenticate.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:clothes_picker/screens/home.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class ProfileView extends StatefulWidget {

  final FirebaseUser _user;

  ProfileView(this._user);

  @override
  _ProfileViewState createState() => _ProfileViewState(_user);
}

class _ProfileViewState extends State<ProfileView> {
  final String _followers = "173";
  final String _customfits = "11";
  final String _likes = "450";

  FirebaseUser _user;
  _ProfileViewState(this._user);
  
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
          image: NetworkImage("https://storage.pixteller.com/designs/designs-images/2019-03-27/05/simple-background-backgrounds-passion-simple-1-5c9b95bd34713.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: <Widget>[
          SizedBox(height: 50),
          _buildProfileImage(),
          _buildFullName()
        ],
      )
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: _imageButton(_changeProfileImage, 140.0, 140.0,
        _user.photoUrl != null
          ? NetworkImage(_user.photoUrl)
          : NetworkImage('https://www.clipartwiki.com/clipimg/detail/197-1979569_no-profile.png'
        )
      ),
    );
  }

  void _changeProfileImage() {
    StorageReference articleRef = FirebaseStorage.instance.ref().child('profile-images');
    String filename = _user.uid;

    if (_user.photoUrl != null) {
      // replace old image
      articleRef.child(filename)
        .delete()
        .then((_) => print('deleted old image'))
        .catchError((err) => print('Failed to delete image: ${err.message}'));
    }

    ImagePicker.pickImage(source: ImageSource.gallery)
      .then((File image) {

        articleRef
          .child(filename)
          .putFile(image)
          .onComplete
          .then((StorageTaskSnapshot snapshot) {
            print('Uploading: $filename');
            snapshot.ref.getDownloadURL()
              .then((dynamic url) {
                print('URL: $url');
                _user.updateProfile(UserUpdateInfo()..photoUrl = url)
                  .then((_) {
                    print('sucessfully set photoUrl to $url');
                    _user.reload()
                      .then((_) => FirebaseAuth.instance.currentUser())
                      .then((FirebaseUser user) {
                        print('reloaded user');
                        setState(() {
                          _user = user;
                        });
                      })
                      .catchError((err) => print('error reloading user, ${err.message}'));
                  })
                  .catchError((err) => print('error setting photoUrl, ${err.message}'));
              });
          });
      });
  }

  Widget _imageButton(Function _onClick, double width, double height, ImageProvider<dynamic> image){
    return RawMaterialButton(
      child: new InkWell(// this is the one you are looking for..........
        onTap: _onClick,
        child: new Container(
          width: width,
          height: height,
          padding: const EdgeInsets.all(20.0),//I used some padding without fixed width and height
          decoration: BoxDecoration(
            image: DecorationImage(
              image:  image,
              fit: BoxFit.cover,
            ),
            shape: BoxShape.circle,
            color: getBackgroundColor(),
          ),
        ),
      ),
    );
  }

  Widget _buildFullName() {
    TextStyle _nameTextStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.black,
      fontSize: 28.0,
      fontWeight: FontWeight.w700,
    );

    return Text(
      _user.displayName ?? '',
      style: _nameTextStyle,
    );
  }

  Widget _buildStatus(BuildContext context) {
    return Container(
      //padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(4.0),
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
      //margin: EdgeInsets.only(top: 4.0),
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
                  _buildStatus(context),
                  _buildStatContainer(),
                  _buildSeparator(screenSize),
                  SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Wardrobe", style: getTextStyle()),    
                      _imageButton( (){print("add article");}, 30.0, 30.0, NetworkImage("http://pngimages.net/sites/default/files/plus-png-image-59147.png"))
                    ],
                  ),
                  SizedBox(height: 4.0),
                  CustomFitCard(),
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

class CustomFitCard extends StatefulWidget {
    @override
    _CustomFitCardState createState() => _CustomFitCardState();
  }
  
  class _CustomFitCardState extends State<CustomFitCard> {
    @override
    Widget build(BuildContext context) {
      return CarouselSlider(
        height: 200.0,
        items: [1,2,3,4,5].map((i) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: MediaQuery.of(context).size.width / 1.5,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, 15),
                      blurRadius: 15
                    ),
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, -10),
                      blurRadius: 15
                    ),
                  ]
                ),
                child: Text('text $i', style: TextStyle(fontSize: 16.0),)
              );
            },
          );
        }).toList(),
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