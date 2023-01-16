import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

const cambioGommePoints = 100;
const cambioOlioPoints = 50;
const cambioBatteriaPoints = 50;
const motorePoints = 100;
const impiantoFrenantePoints = 150;
const altroPoints = 5;
int sceltaPoints=0;



class Manutenzione extends StatefulWidget {


  static const routeName = '/add-manutenzione';

  @override
  _ManutenzioneState createState() => _ManutenzioneState();
}

class _ManutenzioneState extends State<Manutenzione>{

  final GlobalKey<FormState> _formKeyCosto = GlobalKey<FormState>();

  String? typeManutention = 'Tipo di manutenzione';
  double? costoManutenzione;
  String? note;
  int? current_month;
  int? current_year;
  String? ruote = 'Cambio ruote';
  String? olio = 'Cambio olio';
  String? batteria = 'Cambio batteria';
  String? motore = 'Motore';
  String? freni = 'Impianto frenante';
  String? altro = 'Altro';
  double? indexTable = 0;
  int? userPoints;
  DateTime now = new DateTime.now();
  var formatter = new DateFormat('dd-MM-yyyy');


  readPoints() async {
    final doc =  await FirebaseFirestore.instance
        .collection('community')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get();
    userPoints = doc.docs[0].get('points'); //Prelevo il valore di fuel
  }




  List months =
  ['gen', 'feb', 'mar', 'apr', 'mag','giu','lug','ago','set','ott','nov','dic'];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      //extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.blue.shade300, // <-- SEE HERE
        ),
        title:Text('Nuova manutenzione',style: TextStyle(color: Colors.blue.shade300)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        //toolbarHeight: 55,
      ),
      body: Container(
        decoration: const BoxDecoration(
            color: Color(0xFFE3F2FD)
        ),
        child:
        Container(
          padding: EdgeInsets.all(20),
          child:
          Image.asset(
            'images/ImageManutenzione.png',
            height: MediaQuery.of(context).size.height * 0.518,
            width: MediaQuery.of(context).size.width,
            scale: 1.75,
          ),
        ),
      ),
      //Data
      bottomSheet: Container(
        decoration: BoxDecoration(
          color: Color(0xFF90CAF9),
          boxShadow: [
            BoxShadow(
              offset: Offset(0,-3),
              blurRadius: 8,
              color: Colors.black54,
            )
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        height: MediaQuery.of(context).size.height * 0.58,
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.all(16),
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 15.0),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 10,
                      backgroundColor: Colors.blue,
                      shape: StadiumBorder()
                  ),
                  onPressed: () async {
                    DateTime? newDate = await showDatePicker(
                        context: context,
                        locale: const Locale("it", "IT"),
                        initialDate: now,
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                        builder: (conext,child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                                colorScheme: const  ColorScheme.light(
                                  primary: Colors.lightBlue,
                                  onPrimary: Colors.white,
                                  onSurface: Colors.blueAccent,
                                ),
                                textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.lightBlue.shade50,
                                    )
                                )
                            ),
                            child: child!,
                          );
                        }
                    );
                    if (newDate == null) return;
                    setState(() => now = newDate);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8,horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.calendar_month),
                        Text("Data manutenzione: ${formatter.format(now)}")
                      ],
                    ),
                  )
              ),
            ),
            //Manutenzione
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 15.0),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      elevation: 6,
                      backgroundColor: Colors.white,
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
                      //isDense: true,
                      //title: 'Seleziona un tipo di manutenzione',
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
                                      setState(() => typeManutention = ruote!),
                                      Navigator.pop(context),
                                    },
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Align(
                                          heightFactor: 1.5,
                                          alignment: Alignment.center,
                                          child: Image.asset('images/wheel.png',scale: 6),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(vertical:2,horizontal: 10),
                                          alignment: Alignment.bottomCenter,
                                          child: Text('Cambio ruote', style: const TextStyle(
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
                                      setState(() => typeManutention = olio!),
                                      Navigator.pop(context),
                                    },
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Align(
                                          heightFactor: 1.5,
                                          alignment: Alignment.center,
                                          child: Image.asset('images/oil.png',scale: 5.5),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(vertical:2,horizontal: 10),
                                          alignment: Alignment.bottomCenter,
                                          child: Text('Cambio olio', style: const TextStyle(
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
                                      setState(() => typeManutention = batteria!),
                                      Navigator.pop(context),
                                    },
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Align(
                                          heightFactor: 1.5,
                                          alignment: Alignment.center,
                                          child: Image.asset('images/battery.png',scale: 4.6),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(vertical:2,horizontal: 8),
                                          alignment: Alignment.bottomCenter,
                                          child: Text('Cambio batteria', style: const TextStyle(
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
                                      setState(() => typeManutention = motore!),
                                      Navigator.pop(context),
                                    },
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Align(
                                          heightFactor: 1.5,
                                          alignment: Alignment.center,
                                          child: Image.asset('images/Engine.png',scale: 4.4),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(vertical:2,horizontal: 8),
                                          alignment: Alignment.bottomCenter,
                                          child: Text('Motore', style: const TextStyle(
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
                                      setState(() => typeManutention = freni!),
                                      Navigator.pop(context),
                                    },
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Align(
                                          heightFactor: 1.5,
                                          alignment: Alignment.center,
                                          child: Image.asset('images/Brakes.png',scale: 5.5),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(vertical:2,horizontal: 0),
                                          alignment: Alignment.bottomCenter,
                                          child: Text('Impianto frenante', style: const TextStyle(
                                            fontSize: 11.0,
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
                                      setState(() => typeManutention = altro!),
                                      Navigator.pop(context),
                                    },
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Align(
                                          heightFactor: 1.5,
                                          alignment: Alignment.center,
                                          child: Image.asset('images/OtherMaintenance.png',scale: 5),
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
                        Text('$typeManutention', style: TextStyle(color: Colors.black54),)
                      ],
                    ),
                  )
              ),
            ),
            //Costo
            Form(
              key: _formKeyCosto,
              child:
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 15.0),
              child: TextFormField(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')),],
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                  labelText: 'Costo manutenzione',
                  //hintStyle: const TextStyle(fontSize: 14),
                  filled: true,
                  fillColor: Colors.white,
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
                  if (value == null || value.isEmpty) {
                    return 'Inserisci la spesa effettuata';
                  }
                  else {
                    return null;
                  }
                },
                onChanged: (value) {
                  setState(() {
                    costoManutenzione = double.tryParse(value);
                  });
                },
              ),
            ),
            ),
            //Note
            Container(
              margin: const EdgeInsets.symmetric(vertical: 18.0,horizontal: 15.0),
              child: TextFormField(
                maxLines: 4,
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                  labelText: 'Note',
                  //hintStyle: const TextStyle(fontSize: 14),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder:  OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.indigoAccent),
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    note = value;
                  });
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 100.0),
              child: ElevatedButton(
                onPressed: () async{
                     if(!_formKeyCosto.currentState!.validate()){
                    }
                            else {
                       //print('sono in manutenzione');

                       current_month = now.month;
                       current_year = now.year;
                       CollectionReference costi = await FirebaseFirestore
                           .instance.collection('CostiManutenzione');
                       final test = await FirebaseFirestore.instance.collection(
                           'CostiTotaliManutenzione')
                           .doc('$current_year')
                           .collection(FirebaseAuth.instance.currentUser!.uid)
                           .get();
                       final generalCosts = await FirebaseFirestore.instance
                           .collection('CostiGenerali')
                           .doc('$current_year')
                           .collection(FirebaseAuth.instance.currentUser!.uid)
                           .get();
                       note ??= '';
                       final doc = await FirebaseFirestore.instance.collection(
                           'CostiManutenzione').where(
                           'mese', isEqualTo: months[current_month! - 1]).where(
                           'year', isEqualTo: current_year)
                           .where('uid',
                           isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                           .get();
                       var docs = doc.docs;
                       double sum = 0.0;
                       for (int i = 0; i < docs.length; i++) {
                         sum += docs[i]['costo'];
                       }

                       //Indexing
                       final indexing = await FirebaseFirestore.instance
                           .collection('CostiManutenzione')
                           .where('uid',
                           isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                           .orderBy('index', descending: true)
                           .limit(1)
                           .get();
                       var docsIndexing = indexing.docs;
                       if (docsIndexing.isEmpty) {
                         indexTable = 0;
                       }
                       else {
                         var index = docsIndexing[0]['index'];
                         indexTable = index;
                       }


                       if (test.docs.isEmpty) {
                         final docu = await FirebaseFirestore.instance
                             .collection('CostiTotaliManutenzione').doc(
                             '$current_year').collection(
                             FirebaseAuth.instance.currentUser!.uid);
                         for (int i = 0; i < 12; i++) {
                           docu.doc(months[i]).set(
                               {'mese': months[i],
                                 'costoManutenzione': 0,
                                 'index': i,
                               }
                           );
                         }
                       }
                       if (generalCosts.docs.isEmpty) {
                         final docu = await FirebaseFirestore.instance
                             .collection('CostiGenerali')
                             .doc('$current_year')
                             .collection(
                             FirebaseAuth.instance.currentUser!.uid);
                         for (int i = 0; i < 12; i++) {
                           docu.doc(months[i]).set(
                               {'mese': months[i],
                                 'costo': 0,
                                 'index': i,
                                 'totaleLitri': 0,
                               }
                           );
                         }
                       }
                       /*else {
                      final docu = await FirebaseFirestore.instance.collection('CostiTotaliManutenzione').doc('2022').collection(user!.uid);
                      for(int i = 0; i < 12; i++) {
                        docu.doc(months[i]).set(
                            {'mese': months[i],
                              'costo': 0,
                              'index': i,
                            }
                        );
                      }
                    }*/
                       costi.add({
                         'costo': costoManutenzione,
                         'data': formatter.format(now),
                         'type': typeManutention,
                         'note': note,
                         'mese': months[current_month! - 1],
                         'year': now.year.toString(),
                         'uid': FirebaseAuth.instance.currentUser!.uid,
                         'index': indexTable! + 1
                       });

                       await readPoints();


                       if (typeManutention == 'Cambio ruote') {
                         sceltaPoints = cambioGommePoints;
                         userPoints = (userPoints! + sceltaPoints)!;
                       }
                       else if (typeManutention == 'Cambio olio') {
                         sceltaPoints = cambioOlioPoints;
                         userPoints = (userPoints! + cambioOlioPoints)!;
                       }
                       else if (typeManutention == 'Cambio batteria') {
                         sceltaPoints = cambioBatteriaPoints;
                         userPoints = (userPoints! + cambioBatteriaPoints)!;
                       }
                       else if (typeManutention == 'Impianto frenante') {
                         sceltaPoints = impiantoFrenantePoints;
                         userPoints = (userPoints! + impiantoFrenantePoints)!;
                       }
                       else if (typeManutention == 'Motore') {
                         sceltaPoints = motorePoints;
                         userPoints = (userPoints! + motorePoints)!;
                       }
                       else {
                         sceltaPoints = altroPoints;
                         userPoints = (userPoints! + altroPoints)!;
                       }


                       final comm = FirebaseFirestore.instance.collection(
                           "community").doc(
                           FirebaseAuth.instance.currentUser?.uid);
                       comm.update({
                         'points': userPoints
                       }).then((value) => debugPrint("update community!"));


                       await AwesomeDialog(
                         context: context,
                         dialogType: DialogType.success,
                         headerAnimationLoop: false,
                         animType: AnimType.topSlide,
                         title: 'Complimenti!',
                         desc:
                         'Hai ricevuto $sceltaPoints punti!',
                         btnOkOnPress: () {},
                       ).show();


/*
                    FToast.toast(
                      context,
                      msg: "Complimenti!\nHai guadagnato $sceltaPoints punti!",


                      image: Icon(
                        Icons.star_border,
                        color: Colors.yellowAccent,
                      ),

                      imageDirection: AxisDirection.left,
                    );
*/

                       //print(current_year);
                       final doc1 = await FirebaseFirestore.instance.collection(
                           'CostiGenerali').doc('$current_year').collection(
                           FirebaseAuth.instance.currentUser!.uid).where(
                           'mese', isEqualTo: months[current_month! - 1]).get();
                       var docs1 = doc1.docs;
                       double sum1 = 0.0;
                       sum1 += docs1[0]['costo'];
                       //print('somma costo qui $sum1');


                       await FirebaseFirestore.instance.collection(
                           'CostiTotaliManutenzione').doc('$current_year')
                           .collection(FirebaseAuth.instance.currentUser!.uid)
                           .doc('${months[current_month! - 1]}')
                           .update(
                           {"costoManutenzione": sum + costoManutenzione!});

                       await FirebaseFirestore.instance.collection(
                           'CostiGenerali').doc('$current_year').collection(
                           FirebaseAuth.instance.currentUser!.uid).doc(
                           '${months[current_month! - 1]}').update(
                           {"costo": sum1 + costoManutenzione!});


                       Navigator.of(context, rootNavigator: true).pop();
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
                        width: 14,
                      ),
                      Text(
                        "Aggiungi",
                        style: TextStyle(
                          fontSize: 14,
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
    );
  }
}



