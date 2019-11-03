import 'package:flutter/material.dart';

class FitCreaterView extends StatelessWidget {


  Widget _clothSlot(String title, ImageProvider<dynamic> img){
    return Container(
      padding: const EdgeInsets.all(8),
      child: InkWell(
        onTap: () => print("Pressed: " + title),
        child: Container(
          child: Center(
            child: Column(
              children: <Widget>[
                Text(title),
                SizedBox(height: 15),
                Container(
                  width: 100,
                  height: 100,
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
            _clothSlot("Hat", AssetImage('assets/baseball_default.png')),
            _clothSlot("Shirt", AssetImage('assets/shirt_default.jpg')),
            _clothSlot("Accessory", AssetImage('assets/add.png')),
            _clothSlot("Pants", AssetImage('assets/pants_default.png')),
            _clothSlot("Accessory", AssetImage('assets/add.png')),
            _clothSlot("Shoes", AssetImage('assets/shoes_default.png')),	
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