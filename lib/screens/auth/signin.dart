import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SigninScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Login()
      )
    );
  }
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final _formKey = GlobalKey<FormState>();
  final _password = TextEditingController();
  final _email = TextEditingController();
  String _errorText;

  void _login(BuildContext context) {
    if (_password.text.length < 1 || _email.text.length < 1) {
      /* bad input */
      setState(() {
        _errorText = 'Incomplete form';
      });
      return; // no no
    }

    setState(() {
      _errorText = null;
    });

    FirebaseAuth.instance
      .signInWithEmailAndPassword(email: _email.text, password: _password.text)
      .then((AuthResult result) {
        print('logged in ${result.user.uid}');
      })
      .catchError((dynamic err) {
        print('Failed to login: ${err.message}');
        setState(() {
          _errorText = '${err.message}';
        });
      });

  }

  Widget _showError() {
    if (_errorText == null)
      return SizedBox(height: ScreenUtil.getInstance().setHeight(50));

    return (Text(_errorText,
            style: TextStyle(
                fontSize: ScreenUtil.getInstance().setSp(30),
                fontFamily: "Poppins-Medium",
                color: Colors.red,
            letterSpacing: .6)
          ));
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
                    height: ScreenUtil.getInstance().setHeight(650 + (_errorText == null ? 0.0 : 100.0)),

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
                          Text("Login",
                            style: TextStyle(
                                fontSize: ScreenUtil.getInstance().setSp(45),
                                fontFamily: "Poppins-Bold",
                            letterSpacing: .6)
                          ),

                          SizedBox(
                            height: ScreenUtil.getInstance().setHeight(60),
                          ),

                          Text("Username",
                            style: TextStyle(
                                fontFamily: "Poppins-Medium",
                                fontSize: ScreenUtil.getInstance().setSp(32))
                            ),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: _email,
                            decoration: InputDecoration(
                              hintText: "Username",
                              hintStyle: TextStyle(color: Colors.grey, fontSize: 18.0)),
                          ),

                          SizedBox(
                            height: ScreenUtil.getInstance().setHeight(60),
                          ),

                          Text("Password",
                            style: TextStyle(
                                fontFamily: "Poppins-Medium",
                                fontSize: ScreenUtil.getInstance().setSp(32))
                            ),
                          TextFormField(
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                            controller: _password,
                            decoration: InputDecoration(
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.grey, fontSize: 18.0)),
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
                              onTap: () => Navigator.pushNamed(context, '/signup'),
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
                              onTap: () => _login(context),
                              child: Center(
                                child: Text("Sign In",
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