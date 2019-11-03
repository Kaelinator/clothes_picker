import 'package:flutter/material.dart';

class FitCreaterView extends StatelessWidget {


  Widget _clothSlot(String title, ImageProvider<dynamic> img){
    return Container(
      padding: const EdgeInsets.all(8),
      
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text(title),
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: img,
                    fit: BoxFit.cover
                  )
                ),
              )
            ],
          ),
        ),
      ),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0.0, 15.0),
            blurRadius: 15.0
          ),
            BoxShadow(
            color: Colors.black12,
            offset: Offset(0.0, -10.0),
            blurRadius: 15.0
          ),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomScrollView(
        primary: false,
        slivers: <Widget>[
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverGrid.count(
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              children: <Widget>[
                _clothSlot("Hat", AssetImage('assets/baseball_default.png')),
                _clothSlot("Shirt",AssetImage('assets/shirt_default.jpg') ),
                _clothSlot("Accessory",AssetImage('assets/add.jpg') ),
                _clothSlot("Pants", AssetImage('assets/pants_default.png')),
                _clothSlot("Accessory",AssetImage('assets/add.jpg') ),
                _clothSlot("Shoes",AssetImage('assets/shoes_default.png') ),
              ],
            ),
          ),
        ],
      )
    );
  }
}