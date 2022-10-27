import 'package:car_control/Widgets/DottedBorder.dart';
import 'package:flutter/material.dart';


class AddScadenza extends StatefulWidget{
  static const routeName = '/add-scadenza';

  @override
  State<AddScadenza> createState() => _AddScadenzaState();
}

class _AddScadenzaState extends State<AddScadenza> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Scadenze'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        toolbarHeight: 55,
        flexibleSpace: Container(
          decoration:const BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
              gradient: LinearGradient(
                  colors: [Colors.blue,Colors.cyan],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter
              )
          ),
        ),
      ),
      body: Container(
          decoration:const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.cyan, Colors.white70],
              )
          ),
          child: Center(
            child: ListView(
              children:  [
                DotBorder("Aggiungi Assicurazione",
                  attachedFunction: (PointerDownEvent p) {print("Assicurazione");},
                ),
                DotBorder("Aggiungi Bollo",
                  attachedFunction: (PointerDownEvent p) {print("Bollo");},
                ),
                DotBorder("Aggiungi Tagliando",
                  attachedFunction: (PointerDownEvent p) {print("Tagliando");},
                ),
                DotBorder("Aggiungi Revisione gomme",
                  attachedFunction: (PointerDownEvent p) {print("Revisione gomme");},
                ),
              ],
            )
          ),
      ),
    );
  }
}