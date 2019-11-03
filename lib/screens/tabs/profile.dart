import 'dart:io';

import 'package:clothes_picker/screens/add-article.dart';
import 'package:clothes_picker/screens/create-article.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:clothes_picker/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  @override
  void initState() {
    FirebaseAuth.instance.currentUser()
      .then((FirebaseUser user) {
        setState(() {
          _user = user;
        });
      })
      .catchError((err) => print('error loading user, ${err.message}'));
    super.initState();
  }
  
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
            _user.displayName ?? '',
            style: getTextStyle(),
          )
        ],
      )
    );
  }

  Widget _profileImage() {
    return Center(
      child: _imageButton(_changeProfileImage, 140.0, 140.0,
        _user.photoUrl != null
          ? NetworkImage(_user.photoUrl)
          : NetworkImage('https://www.clipartwiki.com/clipimg/detail/197-1979569_no-profile.png')
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
          width: 140,
          height: 140,
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: _user.photoUrl != null
                ? NetworkImage(_user.photoUrl)
                : NetworkImage('https://unmibsg.com/wp-content/uploads/bb-plugin/cache/no-user2-circle.jpg'),
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
          _buildStatItem("Clout", _followers),
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

  void _showDialog(BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Are you really washing your clothes?"),
          content: new Text("Confirming means you will reset your worn clothes for this week."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Back"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Confirm"),
              onPressed: () {
                _resetWardrobe();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _resetWardrobe() {
    print("Resetting Wardrobe");
    return;
  }


  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance =
      ScreenUtil(width: 750, height: 1334, allowFontScaling: true);
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
                  Text("Wardrobe", style: getTextStyle()),
                  Column(
                    children: CLOTHING_TYPES.map(
                      (String type) => CategoryName(type)
                    ).toList().cast<Widget>()
                  ),
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight(60),
                  ),
                  InkWell(
                    child: Container(
                      width: ScreenUtil.getInstance().setWidth(600),
                      height: ScreenUtil.getInstance().setHeight(100),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Color(0xFF17ead9),
                            Color(0xFF6078ea)
                          ]),
                          borderRadius: BorderRadius.circular(6.0),
                          boxShadow: [
                            BoxShadow(
                                color: Color(0xFF6078ea).withOpacity(.3),
                                offset: Offset(0.0, 8.0),
                                blurRadius: 8.0)
                          ]),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () =>_showDialog(context),
                          child: Center(
                            child: Text("Wash Clothing (Reset)",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Poppins-Bold",
                                    fontSize: 16,
                                    letterSpacing: 1.0)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight(30),
                  ),
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

class CategoryName extends StatelessWidget {
  final String categoryName;

  const CategoryName(this.categoryName);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance =
      ScreenUtil(width: 750, height: 1334, allowFontScaling: true);
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: ScreenUtil.getInstance().setHeight(60),
          ),
          InkWell(
            child: Container(
              width: ScreenUtil.getInstance().setWidth(600),
              height: ScreenUtil.getInstance().setHeight(100),
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color(0xFFFF0000),
                    Color(0xFFA13D2D)
                  ]),
                  borderRadius: BorderRadius.circular(6.0),
                  boxShadow: [
                    BoxShadow(
                        color: Color(0xFF6078ea).withOpacity(.3),
                        offset: Offset(0.0, 8.0),
                        blurRadius: 8.0)
                  ]),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Navigator.pushNamed(
                    context, 
                    '/view-article', 
                    arguments: ArticleArguments(categoryName)
                  ),
                  child: Center(
                    child: Text(categoryName,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Poppins-Bold",
                        fontSize: 16,
                        letterSpacing: 1.0
                      )
                    ),
                  ),
                ),
              ),
            ),
          )
        ]
      )
    );
  }
}