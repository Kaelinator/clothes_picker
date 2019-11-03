import 'package:flutter/material.dart';

class FunkyOverlay extends StatefulWidget {

  final String _message;

  FunkyOverlay(this._message);

  @override
  State<StatefulWidget> createState() => FunkyOverlayState(this._message);
}

class FunkyOverlayState extends State<FunkyOverlay>
    with SingleTickerProviderStateMixin {

  AnimationController controller;
  Animation<double> scaleAnimation;
  String _message;

  FunkyOverlayState(this._message);

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
            decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0))),
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Text(this._message),
            ),
          ),
        ),
      ),
    );
  }
}