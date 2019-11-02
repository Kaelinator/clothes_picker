import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

const List<String> CLOTHING_TYPES = <String>[
  'A',
  'B',
  'C'
];

class CreateArticleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CreateArticle()
      )
    );
  }
}

class CreateArticle extends StatefulWidget {
  @override
  _CreateArticleState createState() => _CreateArticleState();
}

class _CreateArticleState extends State<CreateArticle> {
  
  final _formKey = GlobalKey<FormState>();
  // final email = TextEditingController();
  String _type;
  String _errorText;

  void _setType(String type) {
    setState(() {
      _type = type;
    });
  }

  void _createArticle(BuildContext context) {
    if (_type == null) {
      setState(() {
        _errorText = 'Form incomplete';
      });
      return;
    }

    Firestore.instance.collection('articles')
      .document()
      .setData({
        'type': _type
      })
      .then((_) {
        print('created article of clothing');
      })
      .catchError((error) {
        print('Failed to create article of clothing: ${error.message}');
        setState(() {
          _errorText = error.message;
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
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  const Text('Type:'),
                  DropdownButton<String>(
                    value: _type,
                    items: CLOTHING_TYPES.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: _setType,
                  )
                ],
              ),
              _showError(),
              MaterialButton(
                child: const Text('Create Clothing'),
                onPressed: () => _createArticle(context),
              )
            ],
          ),
        )
      )
    );
  }
}