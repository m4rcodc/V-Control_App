import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:car_control/Page/Help.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
const bonusGuide = 10;
const malusGuide = 8;
const kBound = 2;

class Carburante extends StatefulWidget {


  static const routeName = '/add-carburante';

  @override
  _CarburanteState createState() => _CarburanteState();
}

class _CarburanteState extends State<Carburante> {

  //FocusNode myFocusNode = FocusNode();
  final GlobalKey<FormState> _formKeyCosto = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyCostoAlLitro = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyKm = GlobalKey<FormState>();

  double? costoRifornimento;
  double? costoAlLitro;
  double? litri;
  String? labelLitri;
  int? current_month;
  int? current_year;
  String? month;
  String? year;
  int? kmVeicolo;
  int? oldKilometers;
  double? index = 1;
  String? fuel;
  late double totalCost;
  int? userPoints;
  double? indexTable = 0;
  bool sceltaManuale = false;
  String? checkFuel;
  Timer? _timer;


  //Variabile che tiene conto quanti km ha percorso il veicolo in precedenza dall'ultima volta che ha ottenuto
  //Il punteggio dal rifornimento
  int? countRifornimento;

  //Litri di carburante immessi dall'ultima assegnazione di punteggio relativo al rifornimento.
  double? countLitri;

  int? diffKilometers;
  int? consumoMedio;

  readPoints() async {
    final doc =  await FirebaseFirestore.instance
        .collection('community')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get();
    userPoints = doc.docs[0].get('points'); //Prelevo il valore di fuel
  }

   readFuel() async{
   /*final doc = await FirebaseFirestore.instance
        .collection('vehicle')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get();
      setState(() {
        fuel = doc.docs[0].get('fuel');
      });
      sceltaManuale = doc.docs[0].get('sceltaManuale');
      */
     await SharedPreferences.getInstance().then((value) {
       setState(() {
         checkFuel = value.getString('checkFuel');});
       });
       //checkFuel = value.getString('checkFuel');});
    }


  DateTime now = new DateTime.now();
  var formatter = new DateFormat('dd-MM-yyyy');

  List months =
  [
    'gen',
    'feb',
    'mar',
    'apr',
    'mag',
    'giu',
    'lug',
    'ago',
    'set',
    'ott',
    'nov',
    'dic'
  ];


  retriveConsuption() async {
    final doc = await FirebaseFirestore.instance
        .collection('vehicle')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get().then((value) {
      oldKilometers = value.docs[0].get('kilometers');
      countRifornimento = value.docs[0].get('countRifornimento');
      countLitri = value.docs[0].get('countLitri');
      consumoMedio = value.docs[0].get('consumoMedio');
      //debugPrint("Old Km è ${oldKilometers.toString()}");
    });
  }


  @override
  Widget build(BuildContext context) {
    retriveConsuption();
    readFuel();
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.blue.shade300, // <-- SEE HERE
        ),
        title: Text('Nuovo rifornimento',
            style: TextStyle(color: Colors.blue.shade300)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        //toolbarHeight: 55,
      ),
      body:
      Container(
        decoration: const BoxDecoration(
            color: Color(0xFFE3F2FD)
        ),
        child:
        Container(
          padding: EdgeInsets.all(20),
          child:
          Image.asset(
            'images/CarFuelImage.png',
            //fit: BoxFit.cover,
            height: 402,
            width: MediaQuery
                .of(context)
                .size
                .width,
          ),
        ),
      ),
      //Data
      bottomSheet: Container(
        decoration: BoxDecoration(
          color: Color(0xFF90CAF9),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, -3),
              blurRadius: 6,
              color: Colors.black54,
            )
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        height: MediaQuery
            .of(context)
            .size
            .height * 0.58,
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.all(16),
          children: [

            //Data
            Container(
              margin: const EdgeInsets.symmetric(
                  vertical: 10.0, horizontal: 15.0),
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
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
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
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.calendar_month),
                        Text("Data rifornimento: ${formatter.format(now)}")
                      ],
                    ),
                  )
              ),
            ),
            //Costo
            Container(
              margin: const EdgeInsets.symmetric(
                  vertical: 10.0, horizontal: 15.0),
              child:
              Form(
                key: _formKeyCosto,
                child:
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')),
                  ],
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
                    labelText: 'Costo rifornimento',
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
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
                      costoRifornimento = double.tryParse(value);
                    });
                  },
                ),
              ),
            ),
            //Costo al litro
            Container(
              margin: const EdgeInsets.symmetric(
                  vertical: 10.0, horizontal: 15.0),
              child:
              Form(
                key: _formKeyCostoAlLitro,
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')),
                  ],
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
                    labelText: checkFuel == 'Elettrica' ? 'Costo al Kw/h' : 'Costo al litro',
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
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
                      return 'Inserisci il costo al litro';
                    }
                    else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    setState(() {
                      costoAlLitro = double.tryParse(value);
                    });
                  },
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                  vertical: 10.0, horizontal: 15.0),
              child: TextField(
                readOnly: true,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  hintText: calcoloLitri(),
                  //labelLitri == null ? '' : calcoloLitri(),
                  hintStyle: const TextStyle(fontSize: 14),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: checkFuel == 'Elettrica' ? 'Kw/h' : 'Litri',
                  labelStyle: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.indigoAccent),
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),
            //Chilometri veicolo
            Container(
              margin: const EdgeInsets.symmetric(
                  vertical: 10.0, horizontal: 15.0),
              child:
              Form(
                key: _formKeyKm,
                child: TextFormField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9]+')),
                  ],
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    labelStyle: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54
                    ),
                    labelText: 'Chilometri veicolo',
                    //hintStyle: const TextStyle(fontSize: 14),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
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
                      return 'Inserisci il chilometraggio attuale';
                    }
                    else if(int.parse(value) <= oldKilometers!){
                      return "Il valore dev'essere superiore al chilometraggio attuale";
                    }
                    else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    setState(() {
                      kmVeicolo = int.parse(value);
                    });
                  },
                ),
              ),
            ),
            //AddButton
            Container(
              margin: const EdgeInsets.symmetric(
                  vertical: 8.0, horizontal: 90.0),
              child: ElevatedButton(
               onPressed:  () async {
                  if(!_formKeyCosto.currentState!.validate()) {
                  }
                  else
                    if(!_formKeyCostoAlLitro.currentState!.validate()){
                    }
                    else
                      if(!_formKeyKm.currentState!.validate()){
                      }
                      else {

                        current_month = now.month;
                        current_year = now.year;

                        final doc = await FirebaseFirestore.instance
                            .collection('CostiRifornimento')
                            .where('mese', isEqualTo: months[current_month! - 1])
                            .where('year', isEqualTo: current_year.toString())
                            .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                            .get();
                        var docs = doc.docs;
                        double sum = 0.0;
                        double sumLitri = 0.0;
                        print('Lenght: ${docs.length}');
                        for (int i = 0; i < docs.length; i++) {
                          sum += docs[i]['costo'];
                          print('costo $sum');
                        }
                        for (int i = 0; i < docs.length; i++) {
                          sumLitri += docs[i]['litri'];
                          print('litri $sumLitri');
                        }

                        //Indexing
                        final indexing = await FirebaseFirestore.instance
                            .collection('CostiRifornimento')
                            .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
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

                        final test = await FirebaseFirestore.instance
                            .collection('CostiTotali')
                            .doc('$current_year')
                            .collection(FirebaseAuth.instance.currentUser!.uid)
                            .get();
                        final generalCosts = await FirebaseFirestore
                            .instance
                            .collection('CostiGenerali')
                            .doc('$current_year')
                            .collection(FirebaseAuth.instance.currentUser!.uid)
                            .get();

                        if (test.docs.isEmpty) {
                          final docu = await FirebaseFirestore.instance
                              .collection('CostiTotali')
                              .doc('$current_year')
                              .collection(FirebaseAuth.instance.currentUser!.uid);
                          for (int i = 0; i < 12; i++) {
                            docu.doc(months[i]).set(
                                {'mese': months[i],
                                  'costoRifornimento': 0,
                                  'index': i,
                                  'totaleLitri': 0,
                                }
                            );
                          }
                        }
                        if (generalCosts.docs.isEmpty) {
                          final docu = await FirebaseFirestore
                              .instance.collection('CostiGenerali')
                              .doc('$current_year')
                              .collection(FirebaseAuth.instance.currentUser!.uid);
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

                        //debugPrint("I km attuali digitati sono: $kmVeicolo");

                        CollectionReference costi = await FirebaseFirestore
                            .instance.collection('CostiRifornimento');

                        costi.add({
                          'costo': costoRifornimento,
                          'data': formatter.format(now),
                          'year': now.year.toString(),
                          'mese': months[current_month! - 1],
                          'type': 'Rifornimento carburante',
                          'uid': FirebaseAuth.instance.currentUser!.uid,
                          'litri': double.tryParse(labelLitri!),
                          'costoAlLitro': costoAlLitro,
                          'Kilometri veicolo': kmVeicolo,
                          'index': indexTable! + 1,
                          'recapRifornimento': costoRifornimento!,
                          'recapLitri': double.tryParse(labelLitri!)!,
                        });

                        if (sceltaManuale == false) {
                          await readPoints();

                          diffKilometers = (kmVeicolo! - oldKilometers!)!;

                          //L'efficienza di guida relativa al rifornimento che farà il cliente verrà valutata al prossimo rifornimento
                          //contando i chilometri consumati relativi ai litri di benzina precedentemente immessi.


                          countRifornimento =
                          (countRifornimento! + diffKilometers!)!;

                          //debugPrint("Countrifornimento: $countRifornimento");

                          double? consumoEffettuato;

                          if (countRifornimento! >= 100) {
                            consumoEffettuato =
                                (countLitri! / countRifornimento!) * 100;
                            //debugPrint("Consumo Effettuato $consumoEffettuato");
                            countRifornimento = 0;

                            //debugPrint("Count litri $countLitri");

                            if (consumoEffettuato > (consumoMedio! + kBound)) {
                              userPoints = (userPoints! - malusGuide)!;
                              await AwesomeDialog(
                                context: context,
                                dialogType: DialogType.warning,
                                headerAnimationLoop: false,
                                animType: AnimType.topSlide,
                                title: 'Attenzione!',
                                desc:
                                'Ci dispiace, ti sono stati sottratti $malusGuide punti per non aver guidato efficientemente la tua auto.',
                                btnOkOnPress: () {},
                              ).show();
                            } else {
                              userPoints = (userPoints! + bonusGuide)!;
                              await AwesomeDialog(
                                context: context,
                                dialogType: DialogType.success,
                                headerAnimationLoop: false,
                                animType: AnimType.topSlide,
                                title: 'Complimenti!',
                                desc:
                                'Complimenti! Ti sono aggiunti $bonusGuide punti per aver guidato efficientemente la tua auto!',
                                btnOkOnPress: () {},
                              ).show();
                            }

                            final comm = FirebaseFirestore.instance
                                .collection("community").doc(
                                FirebaseAuth.instance.currentUser?.uid);
                            comm.update({
                              'points': userPoints
                            });
                          }
                          else {
                            countLitri = 0;
                            countRifornimento = 0;
                          }


                          final upVehicle = FirebaseFirestore.instance
                              .collection('vehicle')
                              .doc(FirebaseAuth.instance.currentUser?.uid)
                              .update({
                            'kilometers': kmVeicolo,
                            'countLitri': double.tryParse(labelLitri!),
                            'countRifornimento': 0
                          });
                        }
                        else {
                          countLitri =
                          (countLitri! + double.tryParse(labelLitri!)!);
                          final upVehicle = FirebaseFirestore.instance
                              .collection('vehicle')
                              .doc(FirebaseAuth.instance.currentUser?.uid)
                              .update({
                            'kilometers': kmVeicolo,
                            'countLitri': countLitri,
                            'countRifornimento': countRifornimento
                          });
                        }


                        final doc1 = await FirebaseFirestore.instance
                            .collection('CostiGenerali').doc('$current_year')
                            .collection(FirebaseAuth.instance.currentUser!.uid).where(
                            'mese', isEqualTo: months[current_month! - 1])
                            .get();
                        var docs1 = doc1.docs;
                        double sum1 = 0;
                        sum1 += docs1[0]['costo'];

                        //print('Costo sum1 carburante $sum1');

                        await FirebaseFirestore.instance.collection(
                            'CostiTotali').doc('$current_year')
                            .collection(FirebaseAuth.instance.currentUser!.uid)
                            .doc('${months[current_month! - 1]}')
                            .update({
                          "costoRifornimento": sum + costoRifornimento!,
                          "totaleLitri": sumLitri + double.tryParse(
                              labelLitri!)!
                        });

                        //print(sum1 + costoRifornimento!);

                        await FirebaseFirestore.instance.collection(
                            'CostiGenerali').doc('$current_year')
                            .collection(FirebaseAuth.instance.currentUser!.uid)
                            .doc('${months[current_month! - 1]}')
                            .update({"costo": sum1 + costoRifornimento!});


                        Navigator.of(context, rootNavigator: true).pop();
                      };
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
                          fontSize: 18,
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


  String? calcoloLitri() {
    double result;

    if (labelLitri == null) {
      labelLitri = '';
    }
    else if (costoAlLitro != null && costoRifornimento != null) {
      result = (costoRifornimento! / costoAlLitro!);
      result = (result * 100).round() / 100;
      labelLitri = result.toString();
    }

    else {
      labelLitri = '0';
    }

    return labelLitri;
  }

}




