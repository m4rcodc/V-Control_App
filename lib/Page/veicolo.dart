import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:car_control/Page/addVeicolo.dart';
import 'package:car_control/Page/home_page.dart';
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
  var state;

  String? uid = FirebaseAuth.instance.currentUser!.uid;

   checkCar() async {
    final doc =  await FirebaseFirestore.instance
        .collection('vehicle')
        .where('uid', isEqualTo: uid)
        .get();
    if(doc.docs.isNotEmpty){
      state = true;
      print(state);
    }
    else {
      state = false;
      print(state);
    }
  }

  deleteVehicle() async {
    final doc =  await FirebaseFirestore.instance
        .collection('vehicle')
        .where('uid', isEqualTo: uid)
        .get();
    doc.docs[0].reference.delete();
    Navigator.pushNamedAndRemoveUntil(context, HomePage.routeName, (route) => false);

  }

  @override
  initState() {
    super.initState();
    checkCar();
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
        top: 140.0,
        child: Container(
          decoration: BoxDecoration(
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
        left: (MediaQuery.of(context).size.width /2) * 0,
        child: Image.asset('images/LogoApp.png', scale: 6),
      ),
      Positioned(
        top: MediaQuery.of(context).size.height * 0.10,
        left: (MediaQuery.of(context).size.width /2) * 0.44,
        child: Container(
          width: 230,
          height: 150,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20.0),
                  bottomLeft: Radius.circular(20.0),
                  topLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0)
              ),
              border: Border.all(color: Colors.blueAccent,width: 2),
              color: Colors.white,
              image: DecorationImage(
                image: NetworkImage('${vehicle.image}',
                ),
                fit: BoxFit.cover,
              ),
              boxShadow: [
                BoxShadow(
                    color: Colors.black54,
                    blurRadius: 8.0,
                    offset: Offset(0,5)
                ),
              ]
          ),
          /*child:  CircleAvatar(
          radius: 100.0,
          backgroundColor: Colors.blue.shade400,
          child: CircleAvatar(
            radius: 95.0,
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage('${vehicle.image}'),
          ),
        ),*/
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
      )
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
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25),bottomRight: Radius.circular(25)),
            gradient: LinearGradient(
              colors: [Colors.cyan,Color(0xFF90CAF9)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.white, // <-- SEE HERE
        ),
        title: Text('Veicolo', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 10.0,
        toolbarHeight: 50,
        leading:
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.warning,
              headerAnimationLoop: false,
              animType: AnimType.topSlide,
              title: 'Attenzione!',
              desc:
              'Sicuro di voler uscire da questo account?',
              btnCancelText: 'Cancella',
              btnCancelOnPress: () {},
              btnOkOnPress: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) => const LoginPage()));
              },
            ).show();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              if(state == true) {
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
              }
              else {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.warning,
                  headerAnimationLoop: false,
                  animType: AnimType.topSlide,
                  title: 'Attenzione!',
                  desc:
                  'Prima di poter eliminare un veicolo devi aggiungerlo!',
                  btnOkOnPress: () {
                  },
                ).show();
              }
            },
          ),
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(AddVeicolo.routeName);
                /* if(checkCar() == true) {
                Navigator.of(context).pushNamed(AddVeicolo.routeName);
              }
              else {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.warning,
                  headerAnimationLoop: false,
                  animType: AnimType.topSlide,
                  title: 'Attenzione!',
                  desc:
                  'Per aggiungere un secondo veicolo, passa alla funzionalità premium dell\'app!',
                  btnCancelText: 'Cancella',
                  btnCancelOnPress: () {},
                  btnOkOnPress: () {
                    deleteVehicle();
                  },
                ).show();
              }*/
              }
          )
        ],
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
                    if (snapshot.data!.isNotEmpty) {
                      return ListView(
                        shrinkWrap: true,
                        children: vehicle.map(buildVehicle).toList(),
                      );
                    }
                    else {
                      return
                        Column(
                        children: [
                        Container(
                        margin: EdgeInsets.only(top: 100),
                        child: Image.asset(
                         'images/PlaceHolder.png'
                        )
                      ),
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(top: 30),
                              child: Text(
                                  'Per inserire un nuovo veicolo \n\t\t premi il + in alto a destra',
                                style: TextStyle(fontSize: 25,fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Colors.blue.shade400),
                              )
                          ),
                      ],
                        );
                    }
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