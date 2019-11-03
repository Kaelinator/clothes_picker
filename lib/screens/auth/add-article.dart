import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class AddArticleScreen extends StatefulWidget {
  @override
  _AddArticleScreenState createState() => _AddArticleScreenState();
}

class _AddArticleScreenState extends State<AddArticleScreen> {

  final CollectionReference articlesRef = Firestore.instance.collection('articles');
  Stream<QuerySnapshot> _articles;
  String _search;
  
  @override
  void initState() {
    _articles = articlesRef.snapshots();
    super.initState();
  }

  void _searchFor(String text) {
    setState(() {
      _search = text;
    });
    ConcatStream(
      text.split(' ')
        .map((word) => articlesRef.where('keywords', arrayContains: word).snapshots())
    ).toSet()
      .then((Set<QuerySnapshot> unique) {
        setState(() {
          _articles = Stream.fromIterable(unique);
        });
      })
      .catchError((err) {
        print('Failed to query, ${err.message}');
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(100, 100),
        child: TextField(
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