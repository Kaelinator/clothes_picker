import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CustomFitCard extends StatefulWidget {
    @override
    _CustomFitCardState createState() => _CustomFitCardState();
  }
  
  class _CustomFitCardState extends State<CustomFitCard> {
    final double _size = 90;

    @override
    Widget build(BuildContext context) {
      return CarouselSlider(
        height: 200.0,
        items: [1,2,3,4,5].map((i) {
          return Builder(
            builder: (BuildContext context) {
              return InkWell(
                onDoubleTap: () => print("Wear Fit"),
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
                            image: DecorationImage(image: AssetImage('assets/add.png'))
                          ),
                        ),
                        Container(
                          width: _size,
                          height: _size,
                          decoration: BoxDecoration(
                            image: DecorationImage(image: AssetImage('assets/shirt_default.png'))
                          ),
                        ),
                        Container(
                          width: _size,
                          height: _size,
                          decoration: BoxDecoration(
                            image: DecorationImage(image: AssetImage('assets/baseball_default.png'))
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
                            image: DecorationImage(image: AssetImage('assets/add.png'))
                          ),
                        ),
                        Container(
                          width: _size,
                          height: _size,
                          decoration: BoxDecoration(
                            image: DecorationImage(image: AssetImage('assets/pants_default.png'))
                          ),
                        ),
                        Container(
                          width: _size,
                          height: _size,
                          decoration: BoxDecoration(
                            image: DecorationImage(image: AssetImage('assets/shoes_default.png'))
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
          );
        }).toList(),
      );
    }
  } 
