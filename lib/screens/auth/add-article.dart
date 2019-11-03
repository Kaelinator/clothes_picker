import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class ArticleArguments {
  final String type;

  ArticleArguments(this.type);
}

class AddArticleScreen extends StatefulWidget {

  final ArticleArguments _args;
  AddArticleScreen(this._args);

  @override
  _AddArticleScreenState createState() => _AddArticleScreenState(_args);
}

class _AddArticleScreenState extends State<AddArticleScreen> {

  final ArticleArguments _args;
  _AddArticleScreenState(this._args);


  final CollectionReference articlesRef = Firestore.instance.collection('articles');
  Stream<QuerySnapshot> _articles;
  
  @override
  void initState() {
    print('SEARCHING TYPE: ${_args.type}');
    _articles = articlesRef.where('type', isEqualTo: _args.type).snapshots();
    super.initState();
  }

  void _searchFor(String text) {
    setState(() {
      _articles = ConcatStream(
        text.toLowerCase()
          .split(' ')
          .map((word) => articlesRef
            .where('type', isEqualTo: _args.type)
            .where('keywords', arrayContains: word).snapshots())
      );
    });
  }

  void _addToWardrobe(String documentID) {

    FirebaseAuth.instance.currentUser()
      .then((FirebaseUser user) => Firestore.instance
        .collection('users')
        .document(user.uid)
        .setData({
          'cleanArticles': { 'id': documentID, 'count': FieldValue.increment(1) }
        }, merge: true))
      .catchError((err) => print('Failed to add article, ${err.message}'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(100, 100),
        child: TextFormField(
          onChanged: _searchFor,
          decoration: InputDecoration(labelText: 'Search')
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _articles,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Text('Loading...');
            default:
              return ListView(
                children: snapshot.data.documents.map((DocumentSnapshot document) {
                  return ListTile(
                    onTap: () => _addToWardrobe(document.documentID),
                    title: Text(document['name'])
                  );
                }).toList()
              );
          }
        }
      )
    );
  }
}