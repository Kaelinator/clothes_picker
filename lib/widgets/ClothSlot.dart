import 'package:flutter/material.dart';

class ClothSlot extends StatefulWidget {

  final String _title;
  final ImageProvider<dynamic> _img;

  const ClothSlot(this._title, this._img);

  @override
  _ClothSlotState createState() => _ClothSlotState(_title, _img);
}

class _ClothSlotState extends State<ClothSlot> {

  final String _title;
  final ImageProvider<dynamic> _img;

  _ClothSlotState(this._title, this._img);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: InkWell(
        onTap: () => print("Pressed: " + _title),
        child: Container(
          child: Center(
            child: Column(
              children: <Widget>[
                Text(_title, style: TextStyle(fontSize: 20),),
                SizedBox(height: 15),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: _img,
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