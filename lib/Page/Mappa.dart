import 'package:flutter/material.dart';

class Mappa extends StatefulWidget {

  @override
  _MappaState createState() => _MappaState();
}

class _MappaState extends State<Mappa>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text('Mappa'),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 8.0,
          toolbarHeight: 55,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
              gradient: LinearGradient(
                colors: [Colors.cyan,Colors.lightBlue],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft
            )
            ),
          ),
        ),
        body: Container(
          decoration:const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.lightBlue, Colors.white70],
            )
          ),
        child:const Center(
          child: Text('Mappa Screen', style: TextStyle(fontSize: 40)),
        )
        ),
    );
  }
}