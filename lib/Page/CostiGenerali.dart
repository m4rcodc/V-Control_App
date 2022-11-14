import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CostiGenerali extends StatefulWidget{

  @override
  CostiGeneraliState createState() => CostiGeneraliState();
}

class CostiGeneraliState extends State<CostiGenerali>{
  @override


  Widget build(BuildContext context) {

    return Scaffold(
      body:
      Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.lightBlue, Colors.white],
            )
        ),
      ),
    );


  }




}