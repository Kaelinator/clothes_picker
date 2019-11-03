import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class ArticleArguments {
  final String type;
  Future<DocumentReference> _user;

  ArticleArguments(this.type);

  Future<DocumentReference> getUser() {
    if (_user == null) {
      Future<DocumentReference> user = FirebaseAuth.instance.currentUser()
      .then((FirebaseUser user) => Firestore.instance
        .collection('users')
        .document(user.uid));
      return user;
    }
    return _user;
  }
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
    print(Firestore.instance.collection('articles'));
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
    _args.getUser()
      .then((DocumentReference user) => user.setData({
        'articles': { '$documentID': FieldValue.increment(1) }
      }, merge: true))
    .catchError((err) => print('Failed to add article, ${err.message}'));
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334, allowFontScaling: true);
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        title: Text(_args.type)
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(
          context, 
          '/add-article', 
          arguments: ArticleArguments(_args.type)
        ),
        child: Icon(Icons.add)
      ),

      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 28.0, right: 28.0, top: 60.0),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    onChanged: _searchFor,
                    decoration: InputDecoration(
                      hintText: "Search",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 18.0)),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: _articles,
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Text('Loading...');
                        default:
                          return ListView(
                            shrinkWrap: true,
                            children: snapshot.data.documents.map((DocumentSnapshot document) {
                              return ListTile(
                                onTap: () => {
                                _addToWardrobe(document.documentID),
                                },
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(document["imageUrl"]) != null ? 
                                  NetworkImage(document["imageUrl"]) : 
                                  NetworkImage("https://www.iconsdb.com/icons/preview/black/square-xxl.png")
                                ),
                                title: Text(document['name'],
                                    style: TextStyle(
                                      fontFamily: "Poppins-Medium",
                                      fontSize: ScreenUtil.getInstance().setSp(32))
                                ),
                              );
                            }).toList()
                          );
                      }
                    }
                  )
                ]
              )
            )
          )
        ]
      )
    );
  }
}