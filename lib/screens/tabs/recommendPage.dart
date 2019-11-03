import 'package:clothes_picker/screens/tabs/createfit.dart';
import 'package:clothes_picker/screens/tabs/profile.dart';
import 'package:flutter/material.dart';
import '../../widgets/CustomOutfitCard.dart';

class RecommendPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 15),
                  Text('Recommended Fits', style: getTextStyle()),
                  SizedBox(height: 10),
                  CustomFitCard.generate(),
                  SizedBox(height: 15),
                  Text('My Custom Fits', style: getTextStyle()),
                  SizedBox(height: 10),
                  CustomFitCard(Future.value(<Outfit>[])),
                  SizedBox(height: 15),
                ]
              )
            )
          )
        ]
      )
    );
  }
}