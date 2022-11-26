import 'package:animated_button/animated_button.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
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


  String? uid = FirebaseAuth.instance.currentUser!.uid;

  Future<bool?> checkCar() async {

    final doc =  await FirebaseFirestore.instance
        .collection('vehicle')
        .where('uid', isEqualTo: uid)
        .get();
    if(doc.docs[0].exists){
      return true;
    }
    else {
      return false;
    }

  }
  
  deleteVehicle() async {
    
    final doc =  await FirebaseFirestore.instance
        .collection('vehicle')
        .where('uid', isEqualTo: uid)
        .get();
    doc.docs[0].reference.delete();
    
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
        top: 110.0,
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(45.0),
              topRight: Radius.circular(45.0),
            ),
            color: Color(0xFF90CAF9),
            boxShadow: [
              BoxShadow(
                offset: Offset(0,-6),
                blurRadius: 8,
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
        left: (MediaQuery.of(context).size.width /2) * 0.45,
        child:  CircleAvatar(
          radius: 110.0,
          backgroundColor: Colors.blue.shade400,
          child: CircleAvatar(
              radius: 105.0,
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage('${vehicle.image}'),
          )
          ,
        ),
      ),
      Positioned(
        top:  MediaQuery.of(context).size.height * 0.32,
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
                    icon: vehicle.logoImage == null ? Image.asset('images/car-search-icon.png',width: 80,
                      color: Colors.lightBlue ,)
                        :  Image.network(
                      '${vehicle.logoImage}',
                      width: 80,
                      height: 90,
                      //color: Colors.lightBlue,
                    ),
                  ),
                  DetailsCarCard(
                    firstText: "Modello",
                    secondText: '${vehicle.model}',
                    icon: Image.asset(
                      "images/ModelCarImage.png",
                      width: 80,
                      height: 90,
                      //color: Colors.lightBlue ,
                    ),
                  ),

                ]
            ),
            TableRow(
                children: [
                  DetailsCarCard(
                    firstText: "Alimentazione",
                    secondText: '${vehicle.fuel}',
                    icon:
                    Image.network(
                      '${vehicle.imageFuelUrl}',
                      width: 80,
                      height: 90,
                    ),
                  ),
                  DetailsCarCard(
                    firstText: "Km attuali",
                    secondText: '${vehicle.kilometers}',
                    icon: Image.asset(
                      "images/tachimetro-icon.png",
                      width: 80,
                      height: 90,
                      color: Colors.lightBlue.shade300,
                    ),
                  ),
                ],
            ),
          ],
        ),
      ),
    ],
  );


  @override
  Widget build(BuildContext context) {
    if(uid == null)
    {
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => const LoginPage()));
    }
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.blue.shade400, // <-- SEE HERE
        ),
        title: Text('Veicolo', style: TextStyle(color: Colors.blue.shade400)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        //toolbarHeight: 55,
        leading:
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: ()  {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => const LoginPage()));
            },
          ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.warning,
                    headerAnimationLoop: false,
                    animType: AnimType.topSlide,
                    title: 'Attenzione!',
                    desc:
                    'Sicuro di voler elminare il veicolo?',
                    btnCancelText: 'Cancella',
                    btnCancelOnPress: () {},
                    btnOkOnPress: () {
                      deleteVehicle();
                    },
                  ).show();
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
           color: Color(0xFFE3F2FD)
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


