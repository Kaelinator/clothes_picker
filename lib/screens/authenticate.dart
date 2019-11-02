import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Authenticate()
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

  void _createAccount() {
    print('TODO');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
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
                onPressed: _createAccount,
              )
            ],
          )
        )
      )
    );
  }
}