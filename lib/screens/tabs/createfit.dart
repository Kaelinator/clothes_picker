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

  Outfit fit = Outfit.fromList(defaultArticles);


  void createFit(articles){
    setState(() { 
      this.fit = Outfit.fromList(articles);
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

class Article {

  String type;
  String name;
  ImageProvider<dynamic> img; 
  int count;

  Article(this.name, this.type, this.img);

  Article.fromMap(Map<String, dynamic> data) {
    
    count = data['count'];
    if (data['article'] == null)
      return;

    type = data['article']['type'];
    name = data['article']['name'];
    if (data['article']['imageUrl'] != null)
      img = NetworkImage(data['article']['imageUrl']);
  }
}

class Outfit {
  Article hat;
  Article top;
  Article bottom;
  Article shoes;
  Article accessory1;
  Article accessory2;

  Outfit.fromList(List<Article> fit) {
    hat = _get(fit, 0);
    top = _get(fit, 1);
    bottom = _get(fit, 2);
    shoes = _get(fit, 3);
    accessory1 = _get(fit, 4);
    accessory2 = _get(fit, 5);
  }

  Outfit({this.hat, this.top, this.bottom, this.shoes, this.accessory1, this.accessory2});

  Article _get(List<Article> fit, int i) {
    return fit.length > i ? fit[i] : null;
  }

  getAsList(){
    return [hat, top, bottom, shoes, accessory1, accessory2];
  }
}