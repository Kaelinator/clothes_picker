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
  final _password = TextEditingController();
  final _email = TextEditingController();
  String _errorText;

  void _login(BuildContext context) {
    if (_password.text.length < 1 || _email.text.length < 1) {
      /* bad input */
      setState(() {
        _errorText = 'incomplete form';
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
      return Container();

    return Text('$_errorText', style: TextStyle(color: Colors.redAccent, fontSize: 20));
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
                controller: _email,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                controller: _password,
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