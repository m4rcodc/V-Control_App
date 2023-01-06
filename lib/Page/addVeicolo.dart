import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:car_control/Page/home_page.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Widgets/select_photo_options_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/userModel.dart';
const int electricPoints = 500;
const int ibridPoints = 300;
const int metanPoints = 200;
const int gplPoints = 150;
const int benzPoints = 100;
const int dieselPoints = 100;
int sceltaPoints=0;

class AddVeicolo extends StatefulWidget{

  static const routeName = '/add-veicolo';

  @override
  State<AddVeicolo> createState() => _AddVeicoloState();
}

class _AddVeicoloState extends State<AddVeicolo> {

  //Variabile per il metodo imagePicker
  //XFile? image;

  final GlobalKey<FormState> _formKeyPlate = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyType = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyEngine = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyFuel = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyKm = GlobalKey<FormState>();


  FirebaseAuth auth = FirebaseAuth.instance;

  String? make = 'Marca';
  String? model = 'Modello';
  String? plate;
  int? kilometers;
  String? type;
  String? engine;
  String? fuel = 'Tipo di alimentazione';
  String? url;
  String? imageFuelUrl;
  int? userPoints;
  int? consumoMedio;
  var setDefaultMake = false, setDefaultModel = false, setDefaultType;
  bool isInFocus = false;
  int countClick = 0;
  int count = 0;
  int? consumoMedioBenzina;
  int? consumoMedioDiesel;
  int? consumoMedioDefault;
  bool sceltaManuale = false;

  File? image;
  String? imageUrl;

  /*
  void makeSelected(value){
    debugPrint('selected onchange: $value');
    setState(() {
      debugPrint('make selected: $value');
      make = value;
      setDefaultMake = false;
      setDefaultModel = true;
    });
  }

  void modelSelected(value){
    debugPrint('selected onchange: $value');
    setState(() {
      debugPrint('make selected: $value');
      model = value;
      setDefaultModel = false;
    });
  }
*/

  String? selectedValue;

  setModelVehicle() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('modelV', model!);
    await prefs.setString('fuelV', fuel!);
  }


  readUserPoints() async{
    final doc =  await FirebaseFirestore.instance
        .collection('community')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get();
    userPoints = doc.docs[0].get('points'); //Prelevo il valore di fuel//Prelevo il valore di fuel
  }

  readConsumoMedio (String fuel, bool sceltaManuale) async{

    if(sceltaManuale == false)
      {
        final doc = await FirebaseFirestore.instance
            .collection('Model')
            .where('model', isEqualTo: model)
            .get().then((value) {
          consumoMedioDefault = value.docs[0].get('consumoMedio');
          consumoMedio = value.docs[0].get('consumoMedio$fuel');

        }).onError((error, stackTrace) {
          consumoMedio = consumoMedioDefault;
        });
      }
    else{
      consumoMedio = 0;
    }

  }


  @override
  Widget build(BuildContext context) {
    readUserPoints();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.blue.shade300, // <-- SEE HERE
        ),
        title: Text('Aggiungi il tuo veicolo', style: TextStyle(color: Colors.blue.shade300)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Container(
        //padding: EdgeInsets.only(top: 20.0,left: 20.0, right: 20.0),
        decoration:const BoxDecoration(
            color: Color(0xFFE3F2FD)
        ),
        child: ListView(
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height - 80.0,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.transparent,
                ),
                Positioned(
                  top: 1.5,
                  left: (MediaQuery.of(context).size.width /2) * 0,
                  child: Image.asset('images/AddMoto.png', scale: 2.5),
                ),
                Positioned(
                  top: 125.0,
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(45.0),
                        topRight: Radius.circular(45.0),
                      ),
                      color: Color(0xFF90CAF9),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0,-4),
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
                  top: MediaQuery.of(context).size.height * 0,
                  left: (MediaQuery.of(context).size.width /2) * 0.38,
                  child: Image.asset('images/AddCar.png'),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.02,
                  left: (MediaQuery.of(context).size.width /2) * 0.48,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 15.0),
                        child: CircleAvatar(
                            radius: 81.0,
                            backgroundColor: Colors.blue.shade100,
                            child: CircleAvatar(
                              radius: 75.0,
                              backgroundColor: Colors.white70,
                              backgroundImage: image == null ? null : FileImage(File(image!.path)),
                              child: image == null
                                  ? Icon(
                                Icons.add_photo_alternate,
                                color:Colors.grey,
                                size: MediaQuery.of(context).size.width * 0.22,
                              ) : null,
                            )
                        ),
                      ),
                      Positioned(
                        top: 120,
                        left: 100,
                        child: RawMaterialButton(
                          elevation: 10,
                          fillColor: Colors.white70,
                          child: Icon(Icons.add_a_photo),
                          padding: EdgeInsets.all(14.0),
                          shape: CircleBorder(),
                          onPressed: () {
                            //pickMedia(ImageSource.camera);
                            showSelectPhotoOptions(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top:  MediaQuery.of(context).size.height * 0.30,
                  left: 10,
                  right: 10,
                  //height: MediaQuery.of(context).size.height - 120,
                  //width: MediaQuery.of(context).size.width - 80,
                  child: ListView(
                    shrinkWrap: true,
                    children:  [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 12.0,horizontal: 15.0),
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('vehicleType')
                              .orderBy('type')
                              .snapshots(),
                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                            if (!snapshot.hasData) {
                              return Container();
                            }
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                  elevation: 3,
                                  backgroundColor: Colors.white70,
                                  shadowColor: Colors.blue.withOpacity(0.09),
                                  shape: StadiumBorder(),
                                  side: BorderSide(color: Colors.grey, width: 1)
                              ),
                              onPressed: () async {
                                AwesomeDialog(
                                  context: context,
                                  headerAnimationLoop: false,
                                  dialogType: DialogType.noHeader,
                                  padding: EdgeInsets.zero,
                                  dialogBackgroundColor: Colors.blue.shade200,
                                  //width: 300,
                                  body:
                                  Table(
                                    children:  [
                                      TableRow(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                                              height: 180,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  elevation: 10,
                                                  backgroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(12),
                                                    //side: BorderSide(color: Colors.blue,width: 1.5),
                                                  ),
                                                ),
                                                onPressed:  () => {
                                                  setState(() {
                                                    type = 'Auto';
                                                    //setDefaultType = false;
                                                    setDefaultMake = true;
                                                    //setDefaultModel = true;
                                                    //isInFocus = true;
                                                  }
                                                  ),
                                                  Navigator.pop(context),
                                                },
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Align(
                                                      heightFactor: 1.3,
                                                      alignment: Alignment.center,
                                                      child: Image.asset('images/AddCar.png',scale: 5),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.symmetric(vertical:2,horizontal: 10),
                                                      alignment: Alignment.bottomCenter,
                                                      child: Text('Auto', style: const TextStyle(
                                                        fontSize: 20.0,
                                                        color: Color(0xFF1A1316),
                                                      ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              //child: Text(prova!, style: TextStyle(color: Colors.grey)),
                                            ),
                                          ]
                                      ),
                                      TableRow(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                                              height: 180,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    elevation: 10,
                                                    backgroundColor: Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(12),
                                                      //side: BorderSide(color: Colors.blue,width: 1.5),
                                                    )
                                                ),
                                                onPressed:  () => {
                                                  setState(() {
                                                    type = 'Moto';
                                                    //setDefaultType = false;
                                                    setDefaultMake = true;
                                                    //setDefaultModel = true;
                                                    //isInFocus = true;
                                                    },
                                                  ),
                                                  Navigator.pop(context),
                                                },
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Align(
                                                      heightFactor: 1.4,
                                                      alignment: Alignment.center,
                                                      child: Image.asset('images/AddMoto.png',scale: 4),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.symmetric(vertical:2,horizontal: 2),
                                                      alignment: Alignment.bottomCenter,
                                                      child: Text('Moto', style: const TextStyle(
                                                        fontSize: 20.0,
                                                        color: Color(0xFF1A1316),

                                                      ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ]
                                      ),
                                    ],
                                  ),
                                ).show();
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 8,horizontal: 15),
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    //Icon(Icons.calendar_month),
                                    type == null ? Text('Seleziona il tipo di veicolo', style: TextStyle(color: Colors.black54),) : Text('$type', style: TextStyle(color: Colors.black54),)
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      //Make
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 15.0),
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('Make')
                              .where('type', isEqualTo: type)
                              .orderBy('name')
                              .snapshots(),
                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                            if (!snapshot.hasData) {
                              return Container();
                            }
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                  elevation: 3,
                                  backgroundColor: Colors.white70,
                                  shadowColor: Colors.blue.withOpacity(0.09),
                                  shape: StadiumBorder(),
                                  side: BorderSide(color: Colors.grey, width: 1)
                              ),
                              onPressed: setDefaultMake == false ? null :
                                  () async {
                                AwesomeDialog(
                                  context: context,
                                  headerAnimationLoop: false,
                                  dialogType: DialogType.noHeader,
                                  padding: EdgeInsets.zero,
                                  dialogBackgroundColor: Colors.blue.shade200,
                                  body:
                                  Table(
                                    children:  [
                                      TableRow(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                              height: 120,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  elevation: 10,
                                                  backgroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(12),
                                                    //side: BorderSide(color: Colors.blue,width: 1.5),
                                                  ),
                                                ),
                                                onPressed:  () => {
                                                  setState(() {
                                                    make = snapshot.data.docs[0]['name'];
                                                    url = snapshot.data.docs[0]['logo'];
                                                    setDefaultModel = true;
                                                  }
                                                  ),
                                                  Navigator.pop(context),
                                                },
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Align(
                                                      heightFactor: 1.3,
                                                      alignment: Alignment.center,
                                                      child: Image.network('${snapshot.data.docs[0]['logo']}',scale: 8),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.symmetric(vertical:2,horizontal: 10),
                                                      alignment: Alignment.bottomCenter,
                                                      child: Text('${snapshot.data.docs[0]['name']}', style: const TextStyle(
                                                        fontSize: 12.0,
                                                        color: Color(0xFF1A1316),
                                                      ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              //child: Text(prova!, style: TextStyle(color: Colors.grey)),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                              height: 120,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    elevation: 10,
                                                    backgroundColor: Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(12),
                                                      //side: BorderSide(color: Colors.blue,width: 1.5),
                                                    )
                                                ),
                                                onPressed:  () => {
                                                  setState(() {
                                                    make = snapshot.data.docs[1]['name'];
                                                    url = snapshot.data.docs[1]['logo'];
                                                    setDefaultModel = true;
                                                  }
                                                  ),
                                                  Navigator.pop(context),
                                                },
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Align(
                                                      heightFactor: 1.8,
                                                      alignment: Alignment.center,
                                                      child: Image.network('${snapshot.data.docs[1]['logo']}',scale: 7.5),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.symmetric(vertical:4,horizontal: 10),
                                                      alignment: Alignment.bottomCenter,
                                                      child: Text('${snapshot.data.docs[1]['name']}', style: const TextStyle(
                                                        fontSize: 12.0,
                                                        color: Color(0xFF1A1316),

                                                      ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),

                                          ]
                                      ),
                                      TableRow(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                              height: 120,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    elevation: 10,
                                                    backgroundColor: Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(12),
                                                      //side: BorderSide(color: Colors.blue,width: 1.5),
                                                    )
                                                ),
                                                onPressed:  () => {
                                                  setState(() {
                                                    make = snapshot.data.docs[2]['name'];
                                                    url = snapshot.data.docs[2]['logo'];
                                                    setDefaultModel = true;
                                                  }
                                                  ),
                                                  Navigator.pop(context),
                                                },
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Align(
                                                      heightFactor: 1.4,
                                                      alignment: Alignment.center,
                                                      child: Image.network('${snapshot.data.docs[2]['logo']}',scale: 6.5),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.symmetric(vertical:2,horizontal: 2),
                                                      alignment: Alignment.bottomCenter,
                                                      child: Text('${snapshot.data.docs[2]['name']}', style: const TextStyle(
                                                        fontSize: 12.0,
                                                        color: Color(0xFF1A1316),

                                                      ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                              height: 120,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    elevation: 10,
                                                    backgroundColor: Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(12),
                                                      //side: BorderSide(color: Colors.blue,width: 1.5),
                                                    )
                                                ),
                                                onPressed:  () => {
                                                  setState(() {
                                                    make = snapshot.data.docs[3]['name'];
                                                    url = snapshot.data.docs[3]['logo'];
                                                    setDefaultModel = true;

                                                  }
                                                  ),
                                                  Navigator.pop(context),
                                                },
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Align(
                                                      heightFactor: 1.3,
                                                      alignment: Alignment.center,
                                                      child: Image.network('${snapshot.data.docs[3]['logo']}',scale: 7.2),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.symmetric(vertical:2,horizontal: 8),
                                                      alignment: Alignment.bottomCenter,
                                                      child: Text('${snapshot.data.docs[3]['name']}', style: const TextStyle(
                                                        fontSize: 12.0,
                                                        color: Color(0xFF1A1316),

                                                      ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ]
                                      ),
                                      TableRow(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                              height: 120,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    elevation: 10,
                                                    backgroundColor: Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(12),
                                                      //side: BorderSide(color: Colors.blue,width: 1.5),
                                                    )
                                                ),
                                                onPressed:  () => {
                                                  setState(() {
                                                    make = snapshot.data.docs[4]['name'];
                                                    url = snapshot.data.docs[4]['logo'];
                                                    setDefaultModel = true;
                                                  }
                                                  ),
                                                  Navigator.pop(context),
                                                },
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Align(
                                                      heightFactor: 1.3,
                                                      alignment: Alignment.center,
                                                      child: Image.network('${snapshot.data.docs[4]['logo']}',scale: 7.8),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.symmetric(vertical:2,horizontal: 4),
                                                      alignment: Alignment.bottomCenter,
                                                      child: Text('${snapshot.data.docs[4]['name']}', style: const TextStyle(
                                                        fontSize: 12.0,
                                                        color: Color(0xFF1A1316),

                                                      ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                              height: 120,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    elevation: 10,
                                                    backgroundColor: Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(12),
                                                      //side: BorderSide(color: Colors.blue,width: 1.5),
                                                    )
                                                ),
                                                onPressed:  () => {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) => AlertDialog(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.all(Radius.circular(32.0))),
                                                          title: Text('Inserisci la marca del tuo veicolo'),
                                                          content: TextFormField(
                                                            autofocus: true,
                                                            decoration: InputDecoration(hintText: 'Inserisci qui'),
                                                            onChanged: (value) {
                                                              setState(() {
                                                                make = value;
                                                                url = null;
                                                                setDefaultModel = true;
                                                                sceltaManuale = true;
                                                              });
                                                            },
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                              child: Text('Inserisci'),
                                                              onPressed: () {
                                                                var nav =  Navigator.of(context);
                                                                nav.pop();
                                                                nav.pop();
                                                              },
                                                            )
                                                          ]
                                                      )
                                                  ),
                                                  //Navigator.pop(context),
                                                },
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Align(
                                                      heightFactor: 1.4,
                                                      alignment: Alignment.center,
                                                      child: type == 'Auto' ?  Image.asset('images/AddCar.png',scale: 8) : Image.asset('images/AddMoto.png',scale: 6.5),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.symmetric(vertical:2,horizontal: 6),
                                                      alignment: Alignment.bottomCenter,
                                                      child: Text('Altro', style: const TextStyle(
                                                        fontSize: 12.0,
                                                        color: Color(0xFF1A1316),

                                                      ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ]
                                      ),
                                    ],
                                  ),
                                ).show();
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 8,horizontal: 15),
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    //Icon(Icons.calendar_month),
                                    Text('$make', style: TextStyle(color: Colors.black54),)
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      //Model
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 15.0),
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('Model')
                              .where('make', isEqualTo: make)
                              .orderBy('model')
                              .snapshots(),
                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                            if (!snapshot.hasData) {
                              debugPrint('snapshot status: ${snapshot.error}');
                              return Container(
                                child:
                                Text(
                                    'snapshot empty make: $make makeModel: $model'),
                              );
                            }
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                  elevation: 3,
                                  backgroundColor: Colors.white70,
                                  shadowColor: Colors.blue.withOpacity(0.09),
                                  shape: StadiumBorder(),
                                  side: BorderSide(color: Colors.grey, width: 1)
                              ),
                              onPressed: setDefaultModel == false ? null :
                                  () async {
                                url == null ?
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(32.0))),
                                        title: Text('Inserisci il modello del tuo veicolo'),
                                        content: TextFormField(
                                          autofocus: true,
                                          decoration: InputDecoration(hintText: 'Inserisci qui'),
                                          onChanged: (value) {
                                            setState(() {
                                              model = value;
                                              url = null;
                                              sceltaManuale = true;
                                            });
                                          },
                                        ),
                                        actions: [
                                          TextButton(
                                            child: Text('Inserisci'),
                                            onPressed: () {
                                              var nav =  Navigator.of(context);
                                              nav.pop();
                                            },
                                          )
                                        ]
                                    )
                                )
                                    :
                                AwesomeDialog(
                                  context: context,
                                  headerAnimationLoop: false,
                                  dialogType: DialogType.noHeader,
                                  padding: EdgeInsets.zero,
                                  dialogBackgroundColor: Colors.blue.shade200,
                                  body:
                                  ListView(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.symmetric(vertical: 2,horizontal:12),
                                    children: [
                                      Container(
                                        //padding: EdgeInsets.symmetric(vertical:10, horizontal:10),
                                          alignment: Alignment.topCenter,
                                          child: Image.network('$url', scale: 5)
                                      ),
                                      Container(
                                          padding: EdgeInsets.symmetric(vertical: 6),
                                          child:
                                          type == 'Auto' ?
                                          Table(
                                              children: [
                                                TableRow(
                                                    children: [
                                                      Container(
                                                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                                                          height: 80,
                                                          child: ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                              elevation: 10,
                                                              backgroundColor: Colors.white,
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(12),
                                                                //side: BorderSide(color: Colors.blue,width: 1.5),
                                                              ),
                                                            ),
                                                            onPressed: (){
                                                              setState(() {
                                                                model = snapshot.data.docs[0]['model'];

                                                              });
                                                              Navigator.pop(context);
                                                            },

                                                            child:
                                                            Text('${snapshot.data.docs[0]['model']}', style: TextStyle(
                                                                fontSize: 20,
                                                                color: Color(0xFF1A1316)
                                                            )),

                                                          )
                                                      ),
                                                      Container(
                                                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                                          height: 80,
                                                          child: ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                              elevation: 10,
                                                              backgroundColor: Colors.white,
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(12),
                                                                //side: BorderSide(color: Colors.blue,width: 1.5),
                                                              ),
                                                            ),
                                                            onPressed: (){
                                                              setState(() {
                                                                model = snapshot.data.docs[1]['model'];
                                                                sceltaManuale = false;

                                                              });
                                                              Navigator.pop(context);
                                                            },
                                                            child: Container(
                                                              child: Text('${snapshot.data.docs[1]['model']}', style: TextStyle(
                                                                  fontSize: 20,
                                                                  color: Color(0xFF1A1316)
                                                              )),
                                                            ),
                                                          )
                                                      )
                                                    ]
                                                ),
                                                TableRow(
                                                    children: [
                                                      Container(
                                                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                                                          height: 80,
                                                          child: ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                              elevation: 10,
                                                              backgroundColor: Colors.white,
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(12),
                                                                //side: BorderSide(color: Colors.blue,width: 1.5),
                                                              ),
                                                            ),
                                                            onPressed: (){
                                                              setState(() {
                                                                model = snapshot.data.docs[2]['model'];
                                                                sceltaManuale = false;

                                                              });
                                                              Navigator.pop(context);
                                                            },
                                                            child:
                                                            Text('${snapshot.data.docs[2]['model']}', style: TextStyle(
                                                                fontSize: 20,
                                                                color: Color(0xFF1A1316)
                                                            )),

                                                          )
                                                      ),
                                                      Container(
                                                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                                          height: 80,
                                                          child: ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                              elevation: 10,
                                                              backgroundColor: Colors.white,
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(12),
                                                                //side: BorderSide(color: Colors.blue,width: 1.5),
                                                              ),
                                                            ),
                                                            onPressed: (){
                                                              setState(() {
                                                                model = snapshot.data.docs[3]['model'];
                                                                sceltaManuale = false;

                                                              });
                                                              Navigator.pop(context);
                                                            },
                                                            child:Text('${snapshot.data.docs[3]['model']}', style: TextStyle(
                                                                fontSize: 20,
                                                                color: Color(0xFF1A1316)
                                                            )),
                                                          )
                                                      )
                                                    ]
                                                ),
                                                TableRow(
                                                    children: [
                                                      Container(
                                                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                                                          height: 80,
                                                          child: ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                              elevation: 10,
                                                              backgroundColor: Colors.white,
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(12),
                                                                //side: BorderSide(color: Colors.blue,width: 1.5),
                                                              ),
                                                            ),
                                                            onPressed: (){
                                                              setState(() {
                                                                model = snapshot.data.docs[4]['model'];
                                                                sceltaManuale = false;

                                                              });
                                                              Navigator.pop(context);
                                                            },
                                                            child:
                                                            Text('${snapshot.data.docs[4]['model']}', style: TextStyle(
                                                                fontSize: 20,
                                                                color: Color(0xFF1A1316)
                                                            )),

                                                          )
                                                      ),
                                                      Container(
                                                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                                          height: 80,
                                                          child: ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                              elevation: 10,
                                                              backgroundColor: Colors.white,
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(12),
                                                              ),
                                                            ),
                                                            onPressed:  () => {
                                                              showDialog(
                                                                  context: context,
                                                                  builder: (context) => AlertDialog(
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.all(Radius.circular(32.0))),
                                                                      title: Text('Inserisci il modello del tuo veicolo'),
                                                                      content: TextFormField(
                                                                        autofocus: true,
                                                                        decoration: InputDecoration(hintText: 'Inserisci qui'),
                                                                        onChanged: (value) {
                                                                          setState(() {
                                                                            model = value;
                                                                            sceltaManuale = true;
                                                                          });
                                                                        },
                                                                      ),
                                                                      actions: [
                                                                        TextButton(
                                                                          child: Text('Inserisci'),
                                                                          onPressed: () {
                                                                            var nav =  Navigator.of(context);
                                                                            nav.pop();
                                                                            nav.pop();
                                                                          },
                                                                        )
                                                                      ]
                                                                  )
                                                              )
                                                            },
                                                            child: Container(
                                                              child: Text('Altro' , style: TextStyle(
                                                                  fontSize: 20,
                                                                  color: Color(0xFF1A1316)
                                                              )),
                                                            ),
                                                          )
                                                      )
                                                    ]
                                                )
                                              ]
                                          )
                                          :
                                          Table(
                                              children: [
                                                TableRow(
                                                    children: [
                                                      Container(
                                                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                                                          height: 80,
                                                          child: ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                              elevation: 10,
                                                              backgroundColor: Colors.white,
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(12),
                                                                //side: BorderSide(color: Colors.blue,width: 1.5),
                                                              ),
                                                            ),
                                                            onPressed: (){
                                                              setState(() {
                                                                model = snapshot.data.docs[0]['model'];
                                                                sceltaManuale = false;

                                                              });
                                                              Navigator.pop(context);
                                                            },

                                                            child:
                                                            Text('${snapshot.data.docs[0]['model']}', style: TextStyle(
                                                                fontSize: 20,
                                                                color: Color(0xFF1A1316)
                                                            )),

                                                          )
                                                      ),
                                                      Container(
                                                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                                          height: 80,
                                                          child: ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                              elevation: 10,
                                                              backgroundColor: Colors.white,
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(12),
                                                                //side: BorderSide(color: Colors.blue,width: 1.5),
                                                              ),
                                                            ),
                                                            onPressed: (){
                                                              setState(() {
                                                                model = snapshot.data.docs[1]['model'];
                                                                sceltaManuale = false;

                                                              });
                                                              Navigator.pop(context);
                                                            },
                                                            child: Container(
                                                              child: Text('${snapshot.data.docs[1]['model']}', style: TextStyle(
                                                                  fontSize: 18,
                                                                  color: Color(0xFF1A1316)
                                                              )),
                                                            ),
                                                          )
                                                      )
                                                    ]
                                                ),
                                                TableRow(
                                                    children: [
                                                      Container(
                                                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                                                          height: 80,
                                                          child: ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                              elevation: 10,
                                                              backgroundColor: Colors.white,
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(12),
                                                                //side: BorderSide(color: Colors.blue,width: 1.5),
                                                              ),
                                                            ),
                                                            onPressed: (){
                                                              setState(() {
                                                                model = snapshot.data.docs[2]['model'];
                                                                sceltaManuale = false;

                                                              });
                                                              Navigator.pop(context);
                                                            },
                                                            child:
                                                            Text('${snapshot.data.docs[2]['model']}', style: TextStyle(
                                                                fontSize: 20,
                                                                color: Color(0xFF1A1316)
                                                            )),

                                                          )
                                                      ),
                                                      Container(
                                                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                                          height: 80,
                                                          child: ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                              elevation: 10,
                                                              backgroundColor: Colors.white,
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(12),
                                                              ),
                                                            ),
                                                            onPressed:  () => {
                                                              showDialog(
                                                                  context: context,
                                                                  builder: (context) => AlertDialog(
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.all(Radius.circular(32.0))),
                                                                      title: Text('Inserisci il modello del tuo veicolo'),
                                                                      content: TextFormField(
                                                                        autofocus: true,
                                                                        decoration: InputDecoration(hintText: 'Inserisci qui'),
                                                                        onChanged: (value) {
                                                                          setState(() {
                                                                            model = value;
                                                                            sceltaManuale = true;
                                                                          });
                                                                        },
                                                                      ),
                                                                      actions: [
                                                                        TextButton(
                                                                          child: Text('Inserisci'),
                                                                          onPressed: () {
                                                                            var nav =  Navigator.of(context);
                                                                            nav.pop();
                                                                            nav.pop();
                                                                          },
                                                                        )
                                                                      ]
                                                                  )
                                                              )
                                                            },
                                                            child: Container(
                                                              child: Text('Altro' , style: TextStyle(
                                                                  fontSize: 20,
                                                                  color: Color(0xFF1A1316)
                                                              )),
                                                            ),
                                                          )
                                                      )
                                                    ]
                                                )
                                              ]
                                          )
                                      )
                                    ],
                                  ),
                                ).show();
                              },
                              child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8,horizontal: 15),
                                  child: Row(
                                      children: [
                                        Text('$model', style: TextStyle(color: Colors.black54),)
                                      ]
                                  )
                              ),
                            );
                          },
                        ),
                      ),
                      //Alimentazione
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 15.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              elevation: 3,
                              backgroundColor: Colors.white70,
                              shadowColor: Colors.blue.withOpacity(0.09),
                              shape: StadiumBorder(),
                              side: BorderSide(color: Colors.grey, width: 1)
                          ),
                          onPressed: () async {
                            AwesomeDialog(
                              context: context,
                              headerAnimationLoop: false,
                              dialogType: DialogType.noHeader,
                              padding: EdgeInsets.zero,
                              dialogBackgroundColor: Colors.blue.shade200,
                              body:
                              Table(
                                children:  [
                                  TableRow(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                          height: 120,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              elevation: 10,
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                                //side: BorderSide(color: Colors.blue,width: 1.5),
                                              ),
                                            ),
                                            onPressed:  () => {
                                              setState(() {
                                                fuel = 'Benzina';
                                                imageFuelUrl = 'https://firebasestorage.googleapis.com/v0/b/emad2022-23.appspot.com/o/fuelImage%2FBenzina.png?alt=media&token=c846afd4-5011-4e78-ab0a-8eea3011b9f6';
                                                readConsumoMedio(fuel!, sceltaManuale);

                                              }
                                              ),
                                              Navigator.pop(context),
                                            },
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Align(
                                                  heightFactor: 1.3,
                                                  alignment: Alignment.center,
                                                  child: Image.asset('images/Benzina.png',scale: 3),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.symmetric(vertical:2,horizontal: 10),
                                                  alignment: Alignment.bottomCenter,
                                                  child: Text('Benzina', style: const TextStyle(
                                                    fontSize: 15.0,
                                                    color: Color(0xFF1A1316),
                                                  ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          //child: Text(prova!, style: TextStyle(color: Colors.grey)),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                          height: 120,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                elevation: 10,
                                                backgroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                )
                                            ),
                                            onPressed:  () => {
                                              setState(() {
                                                fuel = 'Diesel';
                                                imageFuelUrl = 'https://firebasestorage.googleapis.com/v0/b/emad2022-23.appspot.com/o/fuelImage%2FDiesel.png?alt=media&token=0dd1ea68-8ed5-46d0-a112-00bba2a138b8';
                                                readConsumoMedio(fuel!, sceltaManuale);
                                              }
                                              ),
                                              Navigator.pop(context),
                                            },
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Align(
                                                  heightFactor: 1.4,
                                                  alignment: Alignment.center,
                                                  child: Image.asset('images/Diesel.png',scale: 3.1),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.symmetric(vertical:2,horizontal: 10),
                                                  alignment: Alignment.bottomCenter,
                                                  child: Text('Diesel', style: const TextStyle(
                                                    fontSize: 15.0,
                                                    color: Color(0xFF1A1316),

                                                  ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                      ]
                                  ),
                                  TableRow(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                          height: 120,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                elevation: 10,
                                                backgroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                  //side: BorderSide(color: Colors.blue,width: 1.5),
                                                )
                                            ),
                                            onPressed:  () => {
                                              setState(() {
                                                fuel = 'Gas';
                                                imageFuelUrl = 'https://firebasestorage.googleapis.com/v0/b/emad2022-23.appspot.com/o/fuelImage%2FGasMetano.png?alt=media&token=cfcb9719-5ea6-4755-be38-d2c7c17bea00';
                                                readConsumoMedio(fuel!, sceltaManuale);

                                              }
                                              ),
                                              Navigator.pop(context),
                                            },
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Align(
                                                  heightFactor: 1.2,
                                                  alignment: Alignment.center,
                                                  child: Image.asset('images/GasMetano.png',scale: 3.2),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.symmetric(vertical:2,horizontal: 10),
                                                  alignment: Alignment.bottomCenter,
                                                  child: Text('Gas', style: const TextStyle(
                                                    fontSize: 15.0,
                                                    color: Color(0xFF1A1316),

                                                  ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                          height: 120,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                elevation: 10,
                                                backgroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                  //side: BorderSide(color: Colors.blue,width: 1.5),
                                                )
                                            ),
                                            onPressed:  () => {

                                              setState(() {
                                                fuel = 'Metano';
                                                imageFuelUrl = 'https://firebasestorage.googleapis.com/v0/b/emad2022-23.appspot.com/o/fuelImage%2FGasMetano.png?alt=media&token=cfcb9719-5ea6-4755-be38-d2c7c17bea00';
                                                readConsumoMedio(fuel!, sceltaManuale);

                                              }
                                              ),
                                              Navigator.pop(context),
                                            },
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Align(
                                                  heightFactor: 1.2,
                                                  alignment: Alignment.center,
                                                  child: Image.asset('images/GasMetano.png',scale: 3.2),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.symmetric(vertical:2,horizontal: 8),
                                                  alignment: Alignment.bottomCenter,
                                                  child: Text('Metano', style: const TextStyle(
                                                    fontSize: 15.0,
                                                    color: Color(0xFF1A1316),

                                                  ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ]
                                  ),
                                  TableRow(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                          height: 120,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                elevation: 10,
                                                backgroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                  //side: BorderSide(color: Colors.blue,width: 1.5),
                                                )
                                            ),
                                            onPressed:  () => {
                                              setState(() {
                                                fuel = 'Elettrica';
                                                imageFuelUrl = 'https://firebasestorage.googleapis.com/v0/b/emad2022-23.appspot.com/o/fuelImage%2FElettrica.png?alt=media&token=3d76e48f-26f5-4a7c-882c-ea593f809ba2';
                                                readConsumoMedio(fuel!, sceltaManuale);

                                              }
                                              ),
                                              Navigator.pop(context),
                                            },
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Align(
                                                  heightFactor: 1.4,
                                                  alignment: Alignment.center,
                                                  child: Image.asset('images/Elettrica.png',scale: 3),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.symmetric(vertical:2,horizontal: 10),
                                                  alignment: Alignment.bottomCenter,
                                                  child: Text('Elettrica', style: const TextStyle(
                                                    fontSize: 15.0,
                                                    color: Color(0xFF1A1316),

                                                  ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                          height: 120,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                elevation: 10,
                                                backgroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                  //side: BorderSide(color: Colors.blue,width: 1.5),
                                                )
                                            ),
                                            onPressed:  () => {
                                              setState(() {
                                                fuel = 'Ibrida';
                                                imageFuelUrl = 'https://firebasestorage.googleapis.com/v0/b/emad2022-23.appspot.com/o/fuelImage%2FIbrida.png?alt=media&token=91494a2c-2e3b-4270-a79f-a553fef1c408';
                                                readConsumoMedio(fuel!, sceltaManuale);

                                              }
                                              ),
                                              Navigator.pop(context),
                                            },
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Align(
                                                  heightFactor: 1.4,
                                                  alignment: Alignment.center,
                                                  child: Image.asset('images/Ibrida.png',scale: 3),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.symmetric(vertical:2,horizontal: 10),
                                                  alignment: Alignment.bottomCenter,
                                                  child: Text('Ibrida', style: const TextStyle(
                                                    fontSize: 15.0,
                                                    color: Color(0xFF1A1316),

                                                  ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ]
                                  ),
                                ],
                              ),
                            ).show();
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 8,horizontal: 15),
                            child: Row(
                              //mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //Icon(Icons.calendar_month),
                                Text('$fuel', style: TextStyle(color: Colors.black54),)
                              ],
                            ),
                          ),
                        ),
                      ),
                      //Kilometri
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 15.0),
                        child:
                        Form(
                          key: _formKeyKm,
                          child:
                          TextFormField(
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              hintText: 'Inserisci i kilometri attuali del veicolo',
                              hintStyle: const TextStyle(fontSize: 14),
                              filled: true,
                              fillColor: Colors.white70,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder:  OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.indigoAccent),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            validator: (value) {
                              if(value == null || value.isEmpty){
                                return 'Inserisci i kilometri attuali del veicolo';
                              }
                              else {
                                return null;
                              }
                            },
                            onChanged: (value) {
                              setState(() {
                                kilometers = int.parse(value);
                                debugPrint("I km inseriti sono: ${kilometers.toString()}");
                              });
                            },
                          ),
                        ),
                      ),
                      //ButtonAddVeicolo
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 100.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            if(image == null) {
                              displayCenterMotionToast();
                            }
                            else if(!_formKeyKm.currentState!.validate()){
                              }
                              else {
                                    final vehicle = FirebaseFirestore.instance.collection('vehicle').doc(FirebaseAuth.instance.currentUser?.uid);

                                    debugPrint("Il consumo medio registrato è $consumoMedio");

                                    debugPrint("User 1 ${FirebaseAuth.instance.currentUser?.uid} userpoints: $userPoints");

                                    if(sceltaManuale)
                                      {
                                        url = imageFuelUrl;
                                        model = model?.toUpperCase();
                                        make = make?.toUpperCase();
                                      }

                                    vehicle.set({
                                      'uid': FirebaseAuth.instance.currentUser?.uid,
                                      'make': make,
                                      'model': model,
                                      'kilometers' : kilometers,
                                      'image' : imageUrl,
                                      'logoImage': url,
                                      'fuel' : fuel,
                                      'imageFuelUrl' : imageFuelUrl,
                                      'consumoMedio' : consumoMedio,
                                      'countLitri' : 0.0,
                                      'countRifornimento' : 0,
                                      'sceltaManuale' : sceltaManuale
                                    });

                                    debugPrint("Il consumo medio è ${consumoMedio.toString()}");


                                    if(fuel == 'Metano')
                                    {
                                      sceltaPoints = metanPoints;
                                      userPoints = (userPoints! + metanPoints)!;
                                    }
                                    else if(fuel == 'Elettrica')
                                    {
                                      sceltaPoints = electricPoints;
                                      userPoints = (userPoints! + electricPoints)!;
                                    }
                                    else if(fuel == 'Gas')
                                    {
                                      sceltaPoints = gplPoints;
                                      userPoints = (userPoints! + gplPoints)!;
                                    }
                                    else if(fuel == 'Benzina')
                                    {
                                      sceltaPoints = benzPoints;
                                      userPoints = (userPoints! + benzPoints)!;
                                    }
                                    else if(fuel == 'Diesel')
                                    {
                                      sceltaPoints = dieselPoints;
                                      userPoints = (userPoints! + dieselPoints)!;
                                    }
                                    else
                                    {
                                      sceltaPoints = ibridPoints;
                                      userPoints = (userPoints! + ibridPoints)!;
                                    }

                                    final comm = FirebaseFirestore.instance.collection("community").doc(FirebaseAuth.instance.currentUser?.uid);
                                    await comm.update({
                                      'points' : userPoints,
                                      'model' : model,
                                      'make' : make,
                                      'image' : imageUrl,
                                      'fuel' : fuel
                                    });

                                    debugPrint("Siamo in addVeicolo!\n");


                                    await AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.success,
                                      headerAnimationLoop: false,
                                      animType: AnimType.topSlide,
                                      title: 'Complimenti!',
                                      desc:
                                      'Hai ricevuto $sceltaPoints punti!',
                                      btnOkOnPress: () {
                                      },
                                    ).show();

                                    Navigator.pushNamedAndRemoveUntil(context, HomePage.routeName, (route) => false);

                                }
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 10,
                            backgroundColor: Colors.blue.shade200,
                            shape: const StadiumBorder(),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              // crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: const [
                                Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  "Aggiungi",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }



  Future pickMedia(ImageSource source) async {
    //XFile? file;
    try {
      final image = await ImagePicker().pickImage(source: source);

      if (image == null) return;

      final imageTemp = File(image.path);

      setState(() => this.image = imageTemp);

      upload_image();

    } on PlatformException catch(e) {
      print('Failed to pick image: $e');
    }
  }

  void upload_image() async {

    /*if(image == null){
      Fluttertoast.showToast(msg: "Seleziona un immagine");
      return;
    }*/

    final ref = FirebaseStorage.instance.ref().child('userImages').child('User: ${auth.currentUser!.uid}');
    await ref.putFile(image!);
    final imageURL = await ref.getDownloadURL();

    setState(() => imageUrl = imageURL);
  }

  void displayCenterMotionToast() {
    MotionToast(
      icon: Icons.error,
      primaryColor: Colors.deepOrange,
      title: const Text(
        'Errore!',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      width: 350,
      height: 150,
      description: const Text(
        'Per favore inserisci una foto del tuo veicolo',
      ),
      //description: "Center displayed motion toast",
      position: MotionToastPosition.center,
    ).show(context);
  }


/*
      void pickMedia(ImageSource source) async {
    //XFile? file;
      image = await ImagePicker().pickImage(source: source);
  }
*/
  //Button del widget di supporto
  void showSelectPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.28,
          maxChildSize: 0.4,
          minChildSize: 0.28,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: SelectPhotoOptionsScreen(
                onTap: pickMedia,
              ),
            );
          }),
    );
  }


}

/*
class LoadingScreen extends StatelessWidget{

  static const routeName = '/splash-screen';

  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return AnimatedSplashScreen(
      splash: Lottie.network('https://assets6.lottiefiles.com/packages/lf20_gv7Ovi.json'),
      backgroundColor: Colors.white,
      nextScreen: HomePage(),
      splashIconSize: 250,
      duration: 2200,
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.fade,
      animationDuration: const Duration(seconds: 1),
    );
  }

}
*/



