import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class SignupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Signup()
      )
    );
  }
}

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  final _pass = TextEditingController();
  final _confirmPass = TextEditingController();
  final _email = TextEditingController();
  final _displayName = TextEditingController();
  String errorText;

  void _createAccount() {
    if (_pass.text.length < 1 || _pass.text != _confirmPass.text
    || _email.text.length < 1 || _displayName.text.length < 1) {
      /* bad input */
      setState(() {
        errorText = 'Incomplete form';
      });
      return;
    }

    setState(() {
      errorText = null;
    });

    FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: _email.text,
      password: _pass.text
    ).then((AuthResult result) {
      FirebaseUser user = result.user;
      print('Created user ${user.uid}');
      return user.updateProfile(UserUpdateInfo()..displayName = _displayName.text)
        .then((_) => Firestore.instance.collection('users')
          .document(user.uid)
          .setData({
            'isAdmin': false
          }))
          .catchError((err) {
            print('Failed to create user ${err.message}, deleting user');
            user.delete()
              .then((_) => print('deleted user: ${user.uid}'))
              .catchError((err) => print('Failed to delete user, ${err.message}'));
          });
    })
    .then((_) {
      print('created new user in users');
      Navigator.pop(context);
    })
    .catchError((dynamic err) {
      setState(() {
        errorText = err.message;
      });
    });
  }

  Widget _showError() {
    if (errorText == null)
      return SizedBox(height: ScreenUtil.getInstance().setHeight(50));

    return (Text(errorText,
            style: TextStyle(
                fontSize: ScreenUtil.getInstance().setSp(40),
                fontFamily: "Poppins-Medium",
                color: Colors.red,
            letterSpacing: .6)
          ));
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334, allowFontScaling: true);
    return new Scaffold(  
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: true,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 28.0, right: 28.0, top: 60.0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight(50),
                  ),
                  Container(
                    child: Image.asset('assets/logo.png', fit: BoxFit.cover),
                  ),
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight(25),
                  ),
                  Container(
                    width: double.infinity,
                    height: ScreenUtil.getInstance().setHeight(850 + (errorText == null ? 0.0 : 75.0)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0.0, 15.0),
                          blurRadius: 15.0
                        ),
                          BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0.0, -10.0),
                          blurRadius: 15.0
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Create an Account",
                            style: TextStyle(
                                fontSize: ScreenUtil.getInstance().setSp(45),
                                fontFamily: "Poppins-Bold",
                            letterSpacing: .6)
                          ),
                          Text("Display Name",
                            style: TextStyle(
                                fontFamily: "Poppins-Medium",
                                fontSize: ScreenUtil.getInstance().setSp(26))
                            ),
                          TextFormField(
                            controller: _displayName,
                            decoration: InputDecoration(
                              hintText: "Bevo Longhorn",
                              hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
                          ),
                          SizedBox(
                            height: ScreenUtil.getInstance().setHeight(30),
                          ),
                          Text("Email",
                            style: TextStyle(
                                fontFamily: "Poppins-Medium",
                                fontSize: ScreenUtil.getInstance().setSp(26))
                            ),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: _email,
                            decoration: InputDecoration(
                              hintText: "bevo@longhorn.edu",
                              hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
                          ),
                          SizedBox(
                            height: ScreenUtil.getInstance().setHeight(30),
                          ),
                          Text("Password",
                            style: TextStyle(
                                fontFamily: "Poppins-Medium",
                                fontSize: ScreenUtil.getInstance().setSp(26))
                            ),
                          TextFormField(
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                            controller: _pass,
                            decoration: InputDecoration(
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
                          ),
                          SizedBox(
                            height: ScreenUtil.getInstance().setHeight(30),
                          ),
                          Text("Confirm Password",
                            style: TextStyle(
                                fontFamily: "Poppins-Medium",
                                fontSize: ScreenUtil.getInstance().setSp(26))
                            ),
                          TextFormField(
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                            controller: _confirmPass,
                            decoration: InputDecoration(
                                hintText: "Confirm Password",
                                hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
                          ),
                          _showError(),

                        ],
                      )
                    )
                  ),
                  SizedBox(height: ScreenUtil.getInstance().setHeight(40)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        child: Container(
                          width: ScreenUtil.getInstance().setWidth(300),
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
                              onTap: () => Navigator.pushNamed(context, '/signin'),
                              child: Center(
                                child: Text("Back to Login",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Poppins-Bold",
                                    fontSize: 14,
                                    letterSpacing: 1.0
                                  )
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        child: Container(
                          width: ScreenUtil.getInstance().setWidth(300),
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
                              onTap: _createAccount,
                              child: Center(
                                child: Text("Create Account",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Poppins-Bold",
                                        fontSize: 14,
                                        letterSpacing: 1.0)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      )
    );
  }
}