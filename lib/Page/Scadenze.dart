import 'package:flutter/material.dart';

import '../Widgets/BoxScadenza.dart';

class Scadenze extends StatefulWidget {

  @override
  _ScadenzeState createState() => _ScadenzeState();
}

class _ScadenzeState extends State<Scadenze>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Scadenze'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 8.0,
        toolbarHeight: 55,
        flexibleSpace: Container(
          decoration:const BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
              gradient: LinearGradient(
                  colors: [Colors.cyan,Colors.lightBlue],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
              )
          ),
        ),
      ), /*child:const Center(
            child: Text('Scadenze Screen', style: TextStyle(fontSize: 40)),
          )*/
    body: Container(
    decoration:const BoxDecoration(
          gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.lightBlue, Colors.white70],
          )
      ),
      child: Center(
        child: ListView(
              children:  [
                  BoxScadenza("Assicurazione Auto",
                  "Allianz Direct\nScadenza 14/12/2022",
                  Colors.green,
                  Icons.add_chart_sharp,
                  dettagli: (){},
                  modifica: (){}
                  ),
                      BoxScadenza("Bollo",
                      "Scaduto\n",
                      Colors.red,
                      Icons.account_balance_wallet,
                      dettagli: (){},
                      modifica: (){}
                      )
                     ],
                   )
                 ),
              ),
    );
  }
}