import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

const List<String> CLOTHING_TYPES = <String>[
  'A',
  'B',
  'C'
];

const List<String> WARMTH_TYPES = <String>[
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
  final _name = TextEditingController();
  bool _isRainFriendly = false;
  String _type;
  String _warmth;
  String _errorText;
  File _image;

  void _setType(String type) {
    setState(() {
      _type = type;
    });
  }

  void _setWarmth(String warmth) {
    setState(() {
      _warmth = warmth;
    });
  }

  void _setIsRainFriendly(bool isRainFriendly) {
    setState(() {
      _isRainFriendly = isRainFriendly;
    });
  }

  void _createArticle(BuildContext context) {
    if (_type == null) {
      setState(() {
        _errorText = 'Form incomplete';
      });
      return;
    }

    setState(() {
      _errorText = null;
    });

    Firestore.instance.collection('articles')
      .document()
      .setData({
        // 'image': ,
        'name': _name.text,
        'type': _type,
        'warmth': _warmth,
        'isRainFriendly': _isRainFriendly
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

  void _addImage() {
    
    ImagePicker.pickImage(source: ImageSource.gallery)
      .then((File image) {
        setState(() {
          _image = image;
        });
      });
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
                controller: _name,
                decoration: InputDecoration(labelText: 'Name')
              ),
              MaterialButton(
                child: Text('${_image == null ? 'Add' : 'Change' } photo'),
                onPressed: _addImage,
              ),
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
              Row(
                children: <Widget>[
                  const Text('Warmth:'),
                  DropdownButton<String>(
                    value: _type,
                    items: WARMTH_TYPES.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: _setWarmth,
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Checkbox(
                    value: _isRainFriendly,
                    onChanged: _setIsRainFriendly,
                  ),
                  const Text('Rain friendly'),
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