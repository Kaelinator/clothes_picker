import 'package:flutter/material.dart';
import '../../widgets/ClothSlot.dart';

class FitCreaterView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children: <Widget>[
            ClothSlot("Hat", AssetImage('assets/baseball_default.png')),
            ClothSlot("Shirt", AssetImage('assets/shirt_default.jpg'),),
            ClothSlot("Accessory", AssetImage('assets/add.png')),
            ClothSlot("Pants", AssetImage('assets/pants_default.png')),
            ClothSlot("Accessory", AssetImage('assets/add.png')),
            ClothSlot("Shoes", AssetImage('assets/shoes_default.png')),	
          ],
        )
      ),
      bottomNavigationBar: BottomAppBar(
        child: FlatButton(
          onPressed: () => print("create fit"),
          child: Text("Create Fit"),
        ),
      ),
    );
  }
}