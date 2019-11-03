import 'package:clothes_picker/screens/add-article.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<List<Future<Map<String, dynamic>>>> getUserArticles(Future<DocumentReference> user) {
  return user
    .then((DocumentReference u) => 
      u.get().then((DocumentSnapshot snap) {
        List<Future<Map<String, dynamic>>> list = [];
        if (snap.data == null || snap.data['articles'] == null)
          return list;
        snap.data['articles'].forEach((dynamic key, dynamic value) {
          list.add(Firestore.instance.collection('articles')
            .document(key)
            .get()
            .then((DocumentSnapshot article) {
              return { 'article': article.data, 'key': key, 'count': value };
            })
          );
        });
        return list;
      }
    ));
}

class ViewArticlesScreen extends StatefulWidget {

  final ArticleArguments _args;
  ViewArticlesScreen(this._args);

  @override
  _ViewArticlesScreenState createState() => _ViewArticlesScreenState(_args);
}

class _ViewArticlesScreenState extends State<ViewArticlesScreen> {


  final ArticleArguments _args;
  _ViewArticlesScreenState(this._args);
  List<Future<Map<String, dynamic>>> _articles;

  @override
  void initState() {

    setState(() {
      _articles = [];
    });
    
    getUserArticles(_args.getUser())
      .then((List<Future<Map<String, dynamic>>> list) {
        setState(() {
          _articles = list;
        });
      })
      .catchError((err) => print('Failed to get user articles, ${err.message}'));

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
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
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: _articles.length,
                    itemBuilder: (BuildContext ctxt, int i) {
                      return FutureBuilder(
                        future: _articles[i],
                        builder: (ctxt, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done ) {
                            if (snapshot.data['article']['type'] != _args.type)
                              return Container();
                              return ListTile(
                                leading: CircleAvatar(
                                    backgroundImage: NetworkImage(snapshot.data['article']["imageUrl"]) != null ? 
                                    NetworkImage(snapshot.data['article']["imageUrl"]) : 
                                    NetworkImage("https://www.iconsdb.com/icons/preview/black/square-xxl.png")
                                  ),
                                title: Text(snapshot.data['article']['name'],
                                  style: TextStyle(
                                    fontFamily: "Poppins-Medium",
                                    fontSize: ScreenUtil.getInstance().setSp(32))
                                  ),
                                trailing: Text('${snapshot.data['count']}',
                                  style: TextStyle(
                                    fontFamily: "Poppins-Medium",
                                    fontSize: ScreenUtil.getInstance().setSp(32))
                                  ),
                              );
                          } else {
                            return LinearProgressIndicator();
                          }
                        },
                      );
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