import 'package:clothes_picker/widgets/QuickPopup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'add-article.dart';



class AddCustomArticleScreen extends StatefulWidget {

  final ArticleArguments _args;
  AddCustomArticleScreen(this._args);

  @override
  _AddCustomArticleScreenState createState() => _AddCustomArticleScreenState(_args);
}

class _AddCustomArticleScreenState extends State<AddCustomArticleScreen> {

  final ArticleArguments _args;
  _AddCustomArticleScreenState(this._args);


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
          '/add-custom-article', 
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
                                  Navigator.pop(context, document.data),
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