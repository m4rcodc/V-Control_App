import 'package:car_control/Page/Autolavaggio.dart';
import 'package:car_control/Page/Carburante.dart';
import 'package:car_control/Page/CostiAutolavaggio.dart';
import 'package:car_control/Page/CostiGenerali.dart';
import 'package:car_control/Page/CostiManutenzione.dart';
import 'package:car_control/Page/CostiRifornimento.dart';
import 'package:car_control/Page/Manutenzione.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class Costi extends StatelessWidget {

  static const routeName = '/costi-page';

  final int selectedPage;
  //final double totalCost;
  Costi(this.selectedPage);

  /*
  @override
  CostiState createState() => CostiState();
*/

  @override
  Widget build(BuildContext context) => DefaultTabController(
    initialIndex: selectedPage,
    length: 3,
    child: Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Costi"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
            gradient: LinearGradient(
              colors: [Colors.cyan, Colors.lightBlue],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
        ),
        bottom: const TabBar(
          isScrollable: true,
          indicatorColor: Colors.white,
          indicatorWeight: 5.0,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: [
            Tab(icon: Icon(Icons.public), text: 'Generali'),
            Tab(icon: Icon(Icons.local_gas_station), text: 'Carburante'),
            Tab(icon: Icon(Icons.build), text: 'Manutenzione'),
            //Tab(icon: Icon(Icons.local_car_wash), text: 'Autolavaggio'),
          ],
        ),
        elevation: 8,
        titleSpacing: 20,
      ),
      body:
      Container(
        decoration:const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.lightBlue, Colors.white70],
            )
        ),
        child: TabBarView(
          children: [
            CostiGenerali(),
            CostiRifornimento(),
            CostiManutenzione(),
            //CostiAutolavaggio(),
          ],
        ),
      ),
      /*floatingActionButton: SpeedDial(
        spaceBetweenChildren: 15.0,
        icon: Icons.add,
        activeIcon: Icons.reorder,
        renderOverlay: false,
        elevation: 8.0,
        shape: CircleBorder(),
        backgroundColor: Colors.cyan,
        children: [
          SpeedDialChild(
              child: Icon(Icons.build),
              backgroundColor: Colors.white70,
              labelStyle: TextStyle(fontSize: 18.0, color: Colors.white),
              labelBackgroundColor: Colors.lightBlue.shade300,
              label: 'Manutenzione',
              onTap: () => Navigator.of(context).pushNamed(Manutenzione.routeName)
          ),
          /*SpeedDialChild(
              child: Icon(Icons.local_car_wash),
              labelStyle: TextStyle(fontSize: 18.0, color: Colors.white),
              labelBackgroundColor: Colors.lightBlue.shade300,
              backgroundColor: Colors.white70,
              label: 'Autolavaggio',
              onTap: () => Navigator.of(context).pushNamed(Autolavaggio.routeName)
          ),*/
          SpeedDialChild(
              child: Icon(Icons.local_gas_station),
              labelStyle: TextStyle(fontSize: 18.0, color: Colors.white),
              labelBackgroundColor: Colors.lightBlue.shade300,
              backgroundColor: Colors.white70,
              label: 'Carburante',
              onTap: () => Navigator.of(context).pushNamed(Carburante.routeName)
          ),
        ],
      ),*/
    ),
  );

  }
