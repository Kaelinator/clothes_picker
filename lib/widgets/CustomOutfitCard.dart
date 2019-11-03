import 'dart:async';
import 'dart:math';

import 'package:clothes_picker/screens/tabs/createfit.dart';
import 'package:clothes_picker/screens/view-articles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CustomFitCard extends StatefulWidget {

  Future<List<Outfit>> fits;

  CustomFitCard(this.fits);

  CustomFitCard.generate();

  @override
  _CustomFitCardState createState() => _CustomFitCardState(fits);
}
  
class _CustomFitCardState extends State<CustomFitCard> {
  final double _size = 90;

  Future<List<Outfit>> _fits;

  _CustomFitCardState(Future<List<Outfit>> fits) {
    if (fits == null)
      _fits = _generateOutfits(5);
    _fits = fits;
  }

  Future<List<Outfit>> _generateOutfits(int n) async {

    Future<DocumentReference> user = FirebaseAuth.instance.currentUser()
      .then((FirebaseUser user) => Firestore.instance
        .collection('users')
        .document(user.uid));

    List<Future<Map<String, dynamic>>> futureArticles = await getUserArticles(user);
    List<Article> articles = (await Future.wait(futureArticles))
      .map((Map<String, dynamic> data) => Article.fromMap(data)).toList();
    List<Article> tops = _getArticles(articles, 'Top');
    List<Article> bottoms = _getArticles(articles, 'Bottom');
    List<Article> shoes = _getArticles(articles, 'Shoes');
    List<Article> hats = _getArticles(articles, 'Hat');
    List<Article> accessories = _getArticles(articles, 'Accessory');

    Random r = Random();

    List<Outfit> l =  List<Outfit>(n).map((_) => Outfit(
      hat: getRandom(r, hats),
      top: getRandom(r, tops),
      bottom: getRandom(r, bottoms),
      shoes: getRandom(r, shoes),
      accessory1: getRandom(r, accessories),
      accessory2: getRandom(r, accessories),
    )).toList();

    return l;
  }

  Article getRandom(Random r, List l) {
    return l.length > 0 ? l[r.nextInt(l.length)] : null;
  }

  List<Article> _getArticles(List<Article> articles, String type) {
    return articles.where((Article article) {
      return article.count > 0 && article.type == type;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: _generateOutfits(5),
        builder: (ctxt, snapshot) {
          if (snapshot.connectionState != ConnectionState.done || snapshot.data == null)
            return CircularProgressIndicator();

          return CarouselSlider(
            height: 200.0,
            items: snapshot.data.map<Widget>((Outfit fit) => Builder(
              builder: (BuildContext context) {
                return InkWell(
                  onTap: () => print("Wear Fit"),
                  child: Container(
                    width: MediaQuery.of(context).size.width ,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black)
                    ),
                    child: Center(
                      child: Column(
                      children: <Widget>[
                        SizedBox(height: 8,), 
                        Row(  
                          children: <Widget>[
                          Container(
                            width: _size,
                            height: _size,
                              decoration: BoxDecoration(
                                image: DecorationImage(image: fit.accessory1?.img == null ?  AssetImage('assets/add.png') : fit.accessory1.img)
                            ),
                          ),
                          Container(
                            width: _size,
                            height: _size,
                            decoration: BoxDecoration(
                              image: DecorationImage(image: fit.top?.img == null ? AssetImage('assets/shirt_default.jpg') : fit.top.img)
                            ),
                          ),
                          Container(
                            width: _size,
                            height: _size,
                            decoration: BoxDecoration(
                              image: DecorationImage(image: fit.hat?.img == null ? AssetImage('assets/baseball_default.png') : fit.hat.img)
                            ),
                          ),
                          ],
                        ),
                        Row(     
                          children: <Widget>[
                            Container(
                            width: _size,
                            height: _size,
                            decoration: BoxDecoration(
                              image: DecorationImage(image: fit.accessory2?.img == null ? AssetImage('assets/add.png') : fit.accessory2.img)
                            ),
                          ),
                          Container(
                            width: _size,
                            height: _size,
                            decoration: BoxDecoration(
                              image: DecorationImage(image: fit.bottom?.img == null ? AssetImage('assets/pants_default.png') : fit.bottom.img)
                            ),
                          ),
                          Container(
                            width: _size,
                            height: _size,
                            decoration: BoxDecoration(
                              image: DecorationImage(image: fit.shoes?.img == null ? AssetImage('assets/shoes_default.png') : fit.shoes.img)
                            ),
                          )
                        ],
                        )
                      ],
                    ),
                    )
                  ),
                );
              },
            )
          ).toList()
        );
      },
    );
  }
} 
