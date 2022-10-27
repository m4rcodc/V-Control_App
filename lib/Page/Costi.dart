import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class Costi extends StatefulWidget {

  @override
  CostiState createState() => CostiState();
}

class CostiState extends State<Costi>{
  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 4,
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
              colors: [Colors.green, Colors.lightGreen],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
        ),
        bottom: const TabBar(
          isScrollable: true,
          indicatorColor: Colors.white,
          indicatorWeight: 5,
          tabs: [
            Tab(icon: Icon(Icons.home), text: 'Home'),
            Tab(icon: Icon(Icons.star), text: 'Feed'),
            Tab(icon: Icon(Icons.face), text: 'Profile'),
            Tab(icon: Icon(Icons.settings), text: 'Settings'),
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
                colors: [Colors.lightGreen, Colors.white70],
              )
          ),
        child: TabBarView(
          children: [
            buildPage('Home Page'),
            buildPage('Feed Page'),
            buildPage('Profile Page'),
            buildPage('Settings Page'),
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        spaceBetweenChildren: 15.0,
        icon: Icons.add,
        activeIcon: Icons.reorder,
        renderOverlay: false,
          elevation: 8.0,
          shape: CircleBorder(),
          backgroundColor: Colors.green,
          children: [
      SpeedDialChild(
            child: Icon(Icons.build),
              backgroundColor: Colors.white70,
                labelStyle: TextStyle(fontSize: 18.0),
              labelBackgroundColor: Colors.lightGreen.shade200,
              label: 'Manutenzione',
              onTap: () => print('FIRST CHILD')
    ),
    SpeedDialChild(
          child: Icon(Icons.local_car_wash),
            labelStyle: TextStyle(fontSize: 18.0),
          labelBackgroundColor: Colors.lightGreen.shade200,
          backgroundColor: Colors.white70,
          label: 'Autolavaggio',
          onTap: () => print('SECOND CHILD'),
          ),
    SpeedDialChild(
            child: Icon(Icons.local_gas_station),
            labelStyle: TextStyle(fontSize: 18.0),
            labelBackgroundColor: Colors.lightGreen.shade200,
            backgroundColor: Colors.white70,
            label: 'Carburante',
            //onTap: () => Navigator.of(context).pushNamed(Carburante.routeName)
            ),
            ],
              ),
      ),
    );
  Widget buildPage(String text) => Center(
    child: Text(
      text,
      style: TextStyle(fontSize: 28),
    ),
  );
  }
