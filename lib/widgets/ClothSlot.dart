import 'package:flutter/material.dart';

class ClothSlot extends StatefulWidget {

  final String _title;
  final ImageProvider<dynamic> _img;
  final double _size;

  const ClothSlot(this._title, this._img, this._size);

  @override
  _ClothSlotState createState() => _ClothSlotState(_title, _img, _size);
}

class _ClothSlotState extends State<ClothSlot> {

  final String _title;
  final ImageProvider<dynamic> _img;
  final double _size;

  _ClothSlotState(this._title, this._img, this._size);

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
                Text(_title, style: TextStyle(fontSize: 10),),
                SizedBox(height: 15),
                Container(
                  width: _size,
                  height: _size,
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