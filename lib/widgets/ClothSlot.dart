import 'package:clothes_picker/screens/tabs/createfit.dart';
import 'package:flutter/material.dart';

class ClothSlot extends StatefulWidget {


  final Article _article;

  const ClothSlot(this._article);

  @override
  _ClothSlotState createState() => _ClothSlotState(_article);
}

class _ClothSlotState extends State<ClothSlot> {

  final Article _article;

  _ClothSlotState(this._article);

  void update(){
     print("Pressed: " + _article.name);
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: InkWell(
        onTap: update,
        child: Container(
          child: Center(
            child: Column(
              children: <Widget>[
                Text(_article.type, style: TextStyle(fontSize: 20),),
                SizedBox(height: 15),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: _article.img,
                      fit: BoxFit.cover
                    )
                  ),
                )
              ],
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
        ),
      )
    )
  ); 
  }
}