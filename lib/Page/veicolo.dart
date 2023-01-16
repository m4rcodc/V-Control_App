import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:car_control/Page/addVeicolo.dart';
import 'package:car_control/Page/home_page.dart';
import 'package:car_control/Widgets/DetailsCarCard.dart';
import 'package:car_control/models/vehicle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';

class Veicolo extends StatefulWidget {

  @override
  _VeicoloState createState() => _VeicoloState();
}

class _VeicoloState extends State<Veicolo>{

  var make;
  var state;

  String? uid = FirebaseAuth.instance.currentUser!.uid;
  final prefs = SharedPreferences.getInstance();
  int? userPoints;
  String? fuel;
  String? imgVehicle;

  var state1;

  setModelVehicle(String model, String fuel) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('modelV', model);
    await prefs.setString('fuelV', fuel);
  }

  checkCar() async {
    String fuel;
    final doc =  await FirebaseFirestore.instance
        .collection('vehicle')
        .where('uid', isEqualTo: uid)
        .get();
    if(doc.docs.isNotEmpty){
      state = true;
      String model = doc.docs[0].get('model');
      fuel = doc.docs[0].get('fuel');
      //debugPrint("Il model è $model");
      setModelVehicle(model, fuel);
      //print(state);
      state1 = true;
      //print(fuel);
      if(fuel == null){
        fuel = 'Diesel';
      }
      SharedPreferences.getInstance().then((value) => value.setString('checkFuel', fuel!));
    }
    else {
      state = false;
      state1 = false;
      setModelVehicle('', '');
      fuel = 'Diesel';
      //print(fuel);
      //print(state);
      SharedPreferences.getInstance().then((value) => value.setString('checkFuel', fuel!));
    }
    SharedPreferences.getInstance().then((value) => value.setBool('checkCar', state!));
    //SharedPreferences.getInstance().then((value) => value.setString('checkFuel', fuel!));
  }

  deleteVehicle() async {
    final doc =  await FirebaseFirestore.instance
        .collection('vehicle')
        .where('uid', isEqualTo: uid)
        .get();
    fuel = doc.docs[0].get('fuel'); //Prelevo il valore di fuel
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


  //Leggo i punti dal db
  readUserPoints() async{
    final doc =  await FirebaseFirestore.instance
        .collection('community')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get();
    userPoints = doc.docs[0].get('points'); //Prelevo il valore di fuel
  }


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
        top: MediaQuery.of(context).size.height * 0.01,
        left: (MediaQuery.of(context).size.width /2) * 0,
        child: Image.asset('images/LogoApp.png', scale: 6),
      ),
      Positioned(
        top: MediaQuery.of(context).size.height * 0.10,
        left: (MediaQuery.of(context).size.width /2) * 0.41,
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
                      height: 90,
                      color: Colors.lightBlue.shade300 ,)
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
                    icon: vehicle.type == 'Auto' ?
                    Image.asset(
                      "images/ModelCarImage.png",
                      width: 80,
                      height: 90,
                      //color: Colors.lightBlue ,
                    )
                    :
                    Image.asset(
                      "images/AddMoto.png",
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
                  secondText: '${vehicle.kilometers.toString()}',
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
  Widget build(BuildContext context){

    if(uid == null)
    {
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => const LoginPage()));
    }
    readUserPoints();

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
              btnCancelText: 'No',
              btnOkText: 'Si',
              btnCancelOnPress: () {},
              btnOkOnPress: ()  {
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
    if(state1 == false){
      AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      headerAnimationLoop: false,
      animType: AnimType.topSlide,
      title: 'Attenzione!',
      desc:
      'Aggiungi prima un veicolo!',
      btnOkOnPress: () {
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
      'Sicuro di voler elminare il veicolo? \n\n Perderai tutto il tracciamento dei costi.',
      btnCancelText: 'No',
      btnOkText: 'Si',
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        await deleteVehicle();
        setModelVehicle('', '');
        if (fuel == 'Metano') {
        userPoints = (userPoints! - metanPoints)!;
        }
        else if (fuel == 'Elettrica') {
        userPoints = (userPoints! - electricPoints)!;
        }
        else if (fuel == 'Gas') {
        userPoints = (userPoints! - gplPoints)!;
        }
        else if (fuel == 'Benzina') {
        userPoints = (userPoints! - benzPoints)!;
        }
        else if (fuel == 'Diesel') {
        userPoints = (userPoints! - dieselPoints)!;
        }
        else {
        userPoints = (userPoints! - ibridPoints)!;
        }

        final comm = FirebaseFirestore.instance.collection(
        "community").doc(
        FirebaseAuth.instance.currentUser?.uid);

        await comm.update({
        'points': userPoints,
        'model': '',
        'make': '',
        'image': 'https://firebasestorage.googleapis.com/v0/b/emad2022-23.appspot.com/o/defaultImage%2FLogoApp.png?alt=media&token=815b924d-e981-4fb6-ad76-483a2f591310',
        'fuel': ''
        });


        final docRif = await FirebaseFirestore.instance
            .collection('CostiRifornimento')
            .where('uid', isEqualTo: FirebaseAuth.instance
            .currentUser!.uid)
            .get();
        int sizeRif = docRif.size;
        //print(sizeRif);
        for (int i = 0; i < sizeRif; i++) {
          docRif.docs[i].reference.delete();
        }


        final docMtz = await FirebaseFirestore.instance
            .collection('CostiManutenzione')
            .where('uid', isEqualTo: FirebaseAuth.instance
            .currentUser!.uid)
            .get();
        int sizeMtz = docMtz.size;
        //print(sizeMtz);
        for (int i = 0; i < sizeMtz; i++) {
          docMtz.docs[i].reference.delete();
        }

        //Cancello Costi Totali Rifornimento 2023
        var docTotaliRifornimenti = await FirebaseFirestore.instance
            .collection('CostiTotali').doc('2023')
            .collection(FirebaseAuth.instance.currentUser!.uid).get();
        int sizeDocTotalRif = docTotaliRifornimenti.size;
        //print('Questa è la taglia $sizeDocTotalRif');
        for(int i = 0; i < sizeDocTotalRif; i++){
          docTotaliRifornimenti.docs[i].reference.update({"costoRifornimento": 0, "totaleLitri": 0});
        }

        //Cancello Costi Totali Rifornimento 2022
        var docTotaliRifornimenti2k22 = await FirebaseFirestore.instance
            .collection('CostiTotali').doc('2022')
            .collection(FirebaseAuth.instance.currentUser!.uid).get();
        int sizeDocTotalRif2k22 = docTotaliRifornimenti2k22.size;
        //print('Questa è la taglia $sizeDocTotalRif2k22');
        for(int i = 0; i < sizeDocTotalRif2k22; i++){
          docTotaliRifornimenti2k22.docs[i].reference.update({"costoRifornimento": 0, "totaleLitri": 0});
        }

        //Cancello Costi Totali Manutenzione 2023
        var docTotaliManutenzioni = await FirebaseFirestore.instance
            .collection('CostiTotaliManutenzione').doc('2023')
            .collection(FirebaseAuth.instance.currentUser!.uid).get();
        int sizeDocTotalMtz = docTotaliManutenzioni.size;
        for(int i = 0; i < sizeDocTotalMtz; i++){
          docTotaliManutenzioni.docs[i].reference.update({"costoManutenzione": 0});
        }

        //Cancello Costi Totali Manutenzione 2022
        var docTotaliManutenzioni2K22 = await FirebaseFirestore.instance
            .collection('CostiTotaliManutenzione').doc('2022')
            .collection(FirebaseAuth.instance.currentUser!.uid).get();
        int sizeDocTotalMtz2K22 = docTotaliManutenzioni2K22.size;
        for(int i = 0; i < sizeDocTotalMtz2K22; i++){
          docTotaliManutenzioni2K22.docs[i].reference.update({"costoManutenzione": 0});
        }

        //Cancello Costi Generali 2023
        var docCostiGenerali = await FirebaseFirestore.instance
            .collection('CostiGenerali').doc('2023')
            .collection(FirebaseAuth.instance.currentUser!.uid).get();
        int sizeCostiGenerali = docCostiGenerali.size;
        for(int i = 0; i < sizeCostiGenerali; i++){
          docCostiGenerali.docs[i].reference.update({"costo": 0});
        }

        //Cancello Costi Generali 2022
        var docCostiGenerali2K22 = await FirebaseFirestore.instance
            .collection('CostiGenerali').doc('2022')
            .collection(FirebaseAuth.instance.currentUser!.uid).get();
        int sizeCostiGenerali2K22 = docCostiGenerali2K22.size;
        for(int i = 0; i < sizeCostiGenerali2K22; i++){
          docCostiGenerali2K22.docs[i].reference.update({"costo": 0});
        }

        },
        ).show();

    }}
          ),
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                if(state1 == false) {
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
                    btnOkOnPress: () {
                    },
                  ).show();
                }
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
