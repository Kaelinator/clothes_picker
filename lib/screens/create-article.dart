import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

const List<String> CLOTHING_TYPES = <String>[
  'Hats',
  'Tops',
  'Bottoms',
  'Shoes',
  'Accessories',
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
  bool _isUploadingImage = false;
  String _type;
  String _warmth;
  String _errorText;
  String _imageUrl;
  String _imageName;

  @override
  void initState() {
    super.initState();
  }

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
        'imageUrl': _imageUrl,
        'name': _name.text,
        'type': _type,  
        'warmth': _warmth,
        'isRainFriendly': _isRainFriendly,
        'keywords': _name.text.toLowerCase().split(' ')
      })
      .then((_) {
        print('created article of clothing');
        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Created article!')));
        setState(() {
          _errorText = _imageName = _imageUrl = _type = _warmth = null;
          _isRainFriendly = _isUploadingImage = false;
          _name.text = '';
        });
      })
      .catchError((error) {
        print('Failed to create article of clothing: ${error.message}');
        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Failed to create article')));
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

  void _setImage() {
    StorageReference articleRef = FirebaseStorage.instance.ref().child('articles');

    if (_imageUrl != null) {
      // remove previous image
      articleRef.child(_imageName)
        .delete()
        .then((_) => print('deleted old image'))
        .catchError((err) => print('Failed to delete image: ${err.message}'));
    }
    
    ImagePicker.pickImage(source: ImageSource.gallery)
      .then((File image) {
        setState(() {
          _isUploadingImage = true;
        });

        String filename = Uuid().v4();

        articleRef
          .child(filename)
          .putFile(image)
          .onComplete
          .then((StorageTaskSnapshot snapshot) {
            print('Uploading: $filename');
            snapshot.ref.getDownloadURL()
              .then((dynamic url) {
                print('URL: $url');
                setState(() {
                  _imageUrl = url;
                  _imageName = filename;
                  _isUploadingImage = false;
                });
              });
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
                child: Text(
                  '${_isUploadingImage ? 'Uploading' : (_imageName == null) ? 'Add' : 'Change'} image'
                  ),
                onPressed: _setImage,
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
                    value: _warmth,
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