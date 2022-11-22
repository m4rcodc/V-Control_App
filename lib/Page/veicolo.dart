import 'package:car_control/Page/addVeicolo.dart';
import 'package:car_control/Widgets/DetailsCarCard.dart';
import 'package:car_control/models/vehicle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login_page.dart';

class Veicolo extends StatefulWidget {

  @override
  _VeicoloState createState() => _VeicoloState();
}

class _VeicoloState extends State<Veicolo>{

  var make;


  String uid = FirebaseAuth.instance.currentUser!.uid;

  bool? checkCar(String uid){

    FirebaseFirestore.instance.collection('vehicle')
        .where('uid', isEqualTo: uid)
        .snapshots();

  }

  Stream<List<Vehicle>> readVehicles() => FirebaseFirestore.instance
      .collection('vehicle')
      .where('uid', isEqualTo: uid)
      .snapshots()
      .map((snapshot) =>
       snapshot.docs.map((doc) => Vehicle.fromJson(doc.data())).toList()
);

  Widget buildVehicle(Vehicle vehicle) => Stack(
    children: [
      Container(
        height: MediaQuery.of(context).size.height - 80.0,
        width: MediaQuery.of(context).size.width,
        color: Colors.transparent,
      ),
      Positioned(
        top: 75.0,
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(45.0),
              topRight: Radius.circular(45.0),
            ),
            color: Colors.white54,
            boxShadow: [
              BoxShadow(
                offset: Offset(0,-3),
                blurRadius: 6,
                color: Colors.black12,
              )
            ],
          ),
          height: MediaQuery.of(context).size.height * 0.80,
          width: MediaQuery.of(context).size.width,
        ),
      ),
      Positioned(
        top: MediaQuery.of(context).size.height * 0.02,
        left: (MediaQuery.of(context).size.width /2) - 86.0,
        child:  CircleAvatar(
          radius: 91.0,
          backgroundColor: Colors.cyan,
          child: CircleAvatar(
              radius: 85.0,
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage('${vehicle.image}'),
          )
          ,
        ),
      ),
      Positioned(
        top:  MediaQuery.of(context).size.height * 0.28,
        left: 10,
        right: 10,
        //height: MediaQuery.of(context).size.height - 120,
        //width: MediaQuery.of(context).size.width - 80,
        child: Table(
          children:  [
            TableRow(
                children: [
                  DetailsCarCard(
                    firstText: "Marca",
                    secondText: '${vehicle.make}',
                    icon: Image.asset(
                      "images/car-search-icon.png",
                      width: 40,
                      color: Colors.lightBlue,
                    ),
                  ),
                  DetailsCarCard(
                    firstText: "Modello",
                    secondText: '${vehicle.model}',
                    icon: Image.asset(
                      "images/modello-auto-icon.png",
                      width: 40,
                      color: Colors.lightBlue ,
                    ),
                  ),

                ]
            ),
            TableRow(
                children: [
                  DetailsCarCard(
                    firstText: "Alimentazione",
                    secondText: '${vehicle.fuel}',
                    icon: Image.asset(
                      "images/fuel-pump-icon.png",
                      width: 40,
                      color: Colors.lightBlue ,
                    ),
                  ),
                  DetailsCarCard(
                    firstText: "Cilindrata",
                    secondText: '${vehicle.engine}',
                    icon: Image.asset(
                      "images/engine-auto-icon.png",
                      width: 40,
                      color: Colors.lightBlue ,
                    ),
                  ),

                ]
            ),
            TableRow(
                children: [
                  DetailsCarCard(
                    firstText: "Km attuali",
                    secondText: '${vehicle.kilometers}',
                    icon: Image.asset(
                      "images/tachimetro-icon.png",
                      width: 40,
                      color: Colors.lightBlue ,
                    ),

                  ),
                  DetailsCarCard(
                    firstText: "Targa",
                    secondText: "${vehicle.plate}",
                    icon: Image.asset(
                      "images/license-plate-icon.png",
                      width: 40,
                      color: Colors.lightBlue ,
                    ),
                  ),

                ]
            ),
          ],
        ),
      ),
    ],
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title:const  Text('Veicolo'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        //toolbarHeight: 55,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: ()  {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => const LoginPage()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: ()  => Navigator.of(context).pushNamed(AddVeicolo.routeName),
          )
        ],
        /*flexibleSpace: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
              gradient: LinearGradient(
                  colors: [Colors.cyan,Colors.lightBlue],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft
              )
          ),
        ),*/
      ),
      body:
      Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.lightBlue, Colors.white],
            )
        ),

        child: ListView(
          //physics: NeverScrollableScrollPhysics(),
          children: [
         StreamBuilder<List<Vehicle>>(
             stream: readVehicles(),
          builder: (context,snapshot) {
            if (snapshot.hasData) {
              final vehicle = snapshot.data!;
              return ListView(
                shrinkWrap: true,
                children: vehicle.map(buildVehicle).toList(),
              );
            }
            else{
              return Center(child: CircularProgressIndicator());
            }
          }
      ),
      ],
        ),
      ),
    );
  }
}


