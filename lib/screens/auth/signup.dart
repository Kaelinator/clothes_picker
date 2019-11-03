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

  final _formKey = GlobalKey<FormState>();
  final pass = TextEditingController();
  final confirmPass = TextEditingController();
  final email = TextEditingController();
  String errorText;

  void _createAccount(BuildContext context) {
    if (pass.text.length < 1 || pass.text != confirmPass.text || email.text.length < 1) {
      /* bad input */
      setState(() {
        errorText = 'incomplete form';
      });
      return;
    }

    setState(() {
      errorText = null;
    });

    FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email.text,
      password: pass.text
    ).then((AuthResult result) {
      FirebaseUser user = result.user;
      print('Created user ${user.uid}');
      return Firestore.instance.collection('users')
        .document(user.uid)
        .setData({
          'isAdmin': false
        });
    })
    .then((_) => print('created new user in users'))
    .catchError((dynamic err) {
      setState(() {
        errorText = err.message;
      });
    });
  }

  Widget _showError() {
    if (errorText == null)
      return Container();

    return Text('$errorText', style: TextStyle(color: Colors.redAccent, fontSize: 20));
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true);
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
                    height: ScreenUtil.getInstance().setHeight(200),
                  ),
                  Container(
                    width: double.infinity,
                    height: ScreenUtil.getInstance().setHeight(600),
                    
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
                          Text("Username",
                            style: TextStyle(
                                fontFamily: "Poppins-Medium",
                                fontSize: ScreenUtil.getInstance().setSp(26))
                            ),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: email,
                            decoration: InputDecoration(
                              hintText: "Username",
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
                            controller: pass,
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
                            controller: confirmPass,
                            decoration: InputDecoration(
                                hintText: "Confirm Password",
                                hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
                          ),
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
                              onTap: () => Navigator.pushNamed(context, '/signin'),
                              child: Center(
                                child: Text("Login",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Poppins-Bold",
                                        fontSize: 18,
                                        letterSpacing: 1.0)),
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
                              onTap: () => _createAccount(context),
                              child: Center(
                                child: Text("Create Account",
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