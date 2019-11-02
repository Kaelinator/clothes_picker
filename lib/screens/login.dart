import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
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
      .then((user) => print('logged in!'))
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
    return Container(
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _showError(),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: email,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                controller: pass,
                decoration: InputDecoration(labelText: 'Password'),
              ),
              MaterialButton(
                child: const Text('Login'),
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
    );
  }
}