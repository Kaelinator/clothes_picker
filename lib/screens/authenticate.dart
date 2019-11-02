import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Authenticate()
      )
    );
  }
}

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

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
      return; // no no
    }

    setState(() {
      errorText = null;
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
      margin: EdgeInsets.all(20.0),
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
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                controller: confirmPass,
                decoration: InputDecoration(labelText: 'Confirm Password'),
              ),
              MaterialButton(
                child: const Text('Create Account'),
                onPressed: () => _createAccount(context),
              )
            ],
          )
        )
      )
    );
  }
}