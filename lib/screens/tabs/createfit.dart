import 'package:flutter/material.dart';
import '../../widgets/ClothSlot.dart';

class FitCreaterView extends StatefulWidget {
  @override
  _FitCreaterViewState createState() => _FitCreaterViewState();
}

class _FitCreaterViewState extends State<FitCreaterView> {
  final List<Article> articles = [
    new Article('default', "Hat",  AssetImage('assets/baseball_default.png')),
    new Article('default', "Top",  AssetImage('assets/shirt_default.png')),
    new Article('default', "Accessory",  AssetImage('assets/add.png')),
    new Article('default', "Bottom",  AssetImage('assets/pants_default.png')),
    new Article('default', "Accessory",  AssetImage('assets/add.png')),
    new Article('default', "Shoes",  AssetImage('assets/shoes_default.png')),
  ];

  void createFit(){
    setState(() { 

    });
    print("create fit");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.red,
        child: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children: articles.map((f) => ClothSlot(f)).toList().cast<Widget>(),
        )
      ),
      bottomNavigationBar: BottomAppBar(
        child: FlatButton(
          onPressed: () => createFit(),
          child: Text("Create Fit"),
        ),
      ),
    );
  }
}

class Article{

  final String type;
  final String name;
  final ImageProvider<dynamic> img; 

  Article(this.name, this.type, this.img);
}