import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'ClothSlot.dart';


class CustomFitCard extends StatefulWidget {
    @override
    _CustomFitCardState createState() => _CustomFitCardState();
  }
  
  class _CustomFitCardState extends State<CustomFitCard> {
    @override
    Widget build(BuildContext context) {
      return CarouselSlider(
        height: 200.0,
        items: [1,2,3,4,5].map((i) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: MediaQuery.of(context).size.width ,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, 15),
                      blurRadius: 15
                    ),
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, -10),
                      blurRadius: 15
                    ),
                  ]
                ),
                child: Container(
                  child: GridView.count(
                    primary: false,
                    padding: const EdgeInsets.all(20),
                    crossAxisCount: 3,
                    children: <Widget>[
                      ClothSlot("Accessory", AssetImage('assets/add.png'), 30),
                      ClothSlot("Shirt", AssetImage('assets/shirt_default.jpg'), 30),
                      ClothSlot("Hat", AssetImage('assets/baseball_default.png'), 30),
                      ClothSlot("Accessory", AssetImage('assets/add.png'), 30),
                      ClothSlot("Pants", AssetImage('assets/pants_default.png'), 30),
                      ClothSlot("Shoes", AssetImage('assets/shoes_default.png'), 30),	
                    ],
                  )
                )
              );
            },
          );
        }).toList(),
      );
    }
  } 
