import 'package:flutter/material.dart';
import '../../widgets/ClothSlot.dart';

class FitCreaterView extends StatefulWidget {
  @override
  _FitCreaterViewState createState() => _FitCreaterViewState();
}

class _FitCreaterViewState extends State<FitCreaterView> {

  static final List<Article> defaultArticles = [
    new Article('default', "Hat",  AssetImage('assets/baseball_default.png')),
    new Article('default', "Top",  AssetImage('assets/shirt_default.png')),
    new Article('default', "Accessory",  AssetImage('assets/add.png')),
    new Article('default', "Bottom",  AssetImage('assets/pants_default.png')),
    new Article('default', "Accessory",  AssetImage('assets/add.png')),
    new Article('default', "Shoes",  AssetImage('assets/shoes_default.png')),
  ];

  Fit fit = Fit(defaultArticles[0], defaultArticles[1], defaultArticles[2], defaultArticles[3], defaultArticles[4], defaultArticles[5]);


  void createFit(articles){
    setState(() { 
      this.fit = Fit(articles[0], articles[1], articles[2], articles[3], articles[4], articles[5]);
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
          children: fit.getAsList().map((f) => ClothSlot(f)).toList().cast<Widget>(),
        )
      ),
      bottomNavigationBar: BottomAppBar(
        child: FlatButton(
          onPressed: () => createFit(this.fit.getAsList()),
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

class Fit{
  final Article hat;
  final Article top;
  final Article bottom;
  final Article shoes;
  final Article accessory1;
  final Article accessory2;

  Fit(this.hat, this.top, this.bottom, this.shoes, this.accessory1, this.accessory2);

  getAsList(){
    return [hat, top, bottom, shoes, accessory1, accessory2];
  }
}