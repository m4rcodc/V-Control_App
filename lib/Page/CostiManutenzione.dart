import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CostiManutenzione extends StatefulWidget{

  @override
  CostiManutenzioneState createState() => CostiManutenzioneState();
}

class CostiManutenzioneState extends State<CostiManutenzione>{
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