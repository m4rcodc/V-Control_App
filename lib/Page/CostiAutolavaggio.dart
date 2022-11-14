import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CostiAutolavaggio extends StatefulWidget{

  @override
  CostiAutolavaggioState createState() => CostiAutolavaggioState();
}

class CostiAutolavaggioState extends State<CostiAutolavaggio>{
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