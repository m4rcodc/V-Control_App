import 'package:car_control/Page/addVeicolo.dart';
import 'package:flutter/material.dart';



class Veicolo extends StatefulWidget {

  @override
  _VeicoloState createState() => _VeicoloState();
}

class _VeicoloState extends State<Veicolo>{


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
      title:const  Text('Veicolo'),
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
            padding: EdgeInsets.all(10),
               decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.lightBlue, Colors.white70],
                        )
                    ),
            child: Card(
              elevation: 40,
              color: Colors.grey[300],
              shadowColor: Colors.blue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              margin: EdgeInsets.fromLTRB(30, 10, 30, 10),
              child: Column(
                children: [
                  Image(
                    image: AssetImage(''),
                    fit: BoxFit.fill,
                  ),

                ],
              )
            )
          ),
        floatingActionButton: FloatingActionButton(
             onPressed: ()  => Navigator.of(context).pushNamed(AddVeicolo.routeName),
            //icon: const Icon(Icons.add),
            child: Icon(Icons.add),
            backgroundColor: Colors.cyan,
        ),
    );
  }
    }

