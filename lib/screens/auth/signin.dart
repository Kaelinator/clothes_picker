import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  final pass = TextEditingController();
  final email = TextEditingController();
  String errorText;

  void _login(BuildContext context) {
    if (pass.text.length < 1 || email.text.length < 1) {
      /* bad input */
      setState(() {
        errorText = 'incomplete form';
      });
      return; // no no
    }

    setState(() {
      errorText = null;
    });

    FirebaseAuth.instance
      .signInWithEmailAndPassword(email: email.text, password: pass.text)
      .then((AuthResult result) {
        print('logged in ${result.user.uid}');
      })
      .catchError((dynamic err) {
        print('Failed to login: ${err.message}');
        setState(() {
          errorText = '${err.message}';
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
                    Container(
                      width: double.infinity,
                      height: 500,
                      
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
                          children: <Widget>[
                            Text("Login",
                              style: TextStyle(
                                  fontSize: 45,
                                  fontFamily: "Poppins-Medium",
                              letterSpacing: .6)
                            ),
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              controller: email,
                              decoration: InputDecoration(hintText: 'Email'),
                            ),
                            TextFormField(
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                              controller: pass,
                              decoration: InputDecoration(hintText: 'Password'),
                            ),
                            MaterialButton(
                              child: const Text('Login'),
                              elevation: 8.0,
                              onPressed: () => _login(context),
                            ),
                            Row(
                              children: <Widget>[
                                const Text('Dont\' have an account?'),
                                MaterialButton(
                                  child: const Text('Create Account'),
                                  onPressed: () => Navigator.pushNamed(context, '/signup'),
                                )
                              ],
                            )
                          ],
                        )
                      )
                  )
                ],
              ),
            ),
          ),
        ],
      )
    );
  }
}