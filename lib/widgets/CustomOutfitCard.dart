import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';


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
                width: MediaQuery.of(context).size.width / 1.5,
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
                child: Text('text $i', style: TextStyle(fontSize: 16.0),)
              );
            },
          );
        }).toList(),
      );
    }
  } 
