import 'dart:math';
import 'package:car_control/Page/Costi.dart';
import 'package:car_control/Page/CostiRifornimento.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';



class Carburante extends StatefulWidget {


  static const routeName = '/add-carburante';

  @override
  _CarburanteState createState() => _CarburanteState();
}

class _CarburanteState extends State<Carburante>{

  //FocusNode myFocusNode = FocusNode();

  double? costoRifornimento;
  double? costoAlLitro;
  double? litri;
  String? labelLitri;
  int? current_month;
  int? current_year;
  String? month;
  String? year;
  late double totalCost;

  //DateTime date = DateTime.now();
  DateTime now = new DateTime.now();
  var formatter = new DateFormat('yyyy-MM-dd');
  late String date = formatter.format(now);


  List months =
  ['gen', 'feb', 'mar', 'apr', 'mag','giu','lug','ago','set','ott','nov','dic'];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title:const  Text('Nuovo rifornimento'),
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
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.lightBlue, Colors.white70],
            )
        ),
        child: ListView(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 15.0),
                alignment: Alignment.center,
                child: Image.asset('images/CarFuelImage.png',height: 300,width: 300),
              ),
              //Data
              Container(
                margin: const EdgeInsets.symmetric(vertical: 18.0,horizontal: 15.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Data',
                    labelStyle: const TextStyle(
                      color: Colors.black54,
                    ),
                    hintText: date,
                    hintStyle: const TextStyle(fontSize: 14),
                    filled: true,
                    fillColor: Colors.white70,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder:  OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.indigoAccent),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onTap: () async {
                   DateTime? newDate = await showDatePicker(
                        context: context,
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
                   setState(() =>
                   now = newDate
                   );
                  },
                ),
              ),
              //Costo
              Container(
                margin: const EdgeInsets.symmetric(vertical: 18.0,horizontal: 15.0),
                child: TextFormField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')),],
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    labelStyle: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                    ),
                    labelText: 'Costo rifornimento',
                    filled: true,
                    fillColor: Colors.white70,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder:  OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.indigoAccent),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      costoRifornimento = double.tryParse(value);
                    });
                  },
                ),
              ),
              //Costo al litro
              Container(
                margin: const EdgeInsets.symmetric(vertical: 18.0,horizontal: 15.0),
                child: TextFormField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')),],
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    labelStyle: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                    ),
                    labelText: 'Costo al litro',
                    filled: true,
                    fillColor: Colors.white70,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder:  OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.indigoAccent),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      costoAlLitro = double.tryParse(value);
                    });
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 18.0,horizontal: 15.0),
                child: TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    hintText: calcoloLitri(),
                    //labelLitri == null ? '' : calcoloLitri(),
                    hintStyle: const TextStyle(fontSize: 14),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Litri',
                    labelStyle: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54
                    ),
                    filled: true,
                    fillColor: Colors.white70,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder:  OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.indigoAccent),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
              //Chilometri veicolo
              Container(
                margin: const EdgeInsets.symmetric(vertical: 18.0,horizontal: 15.0),
                child: TextFormField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')),],
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    labelStyle: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54
                    ),
                    labelText: 'Chilometri veicolo',
                    //hintStyle: const TextStyle(fontSize: 14),
                    filled: true,
                    fillColor: Colors.white70,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder:  OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.indigoAccent),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
              //AddButton
              Container(
                margin: const EdgeInsets.symmetric(vertical: 70.0,horizontal: 90.0),
                child: ElevatedButton(
                  onPressed: () => {
                   /* if(image == null) {
                      displayCenterMotionToast()
                    }
                    else if(!_formKeyPlate.currentState!.validate()){
                    }
                    else if(!_formKeyType.currentState!.validate()){
                      }
                      else if(!_formKeyEngine.currentState!.validate()){
                        }
                        else if(!_formKeyFuel.currentState!.validate()){
                          }
                          else if(!_formKeyKm.currentState!.validate()){
                            }
                            else{*/
                                FirebaseAuth.instance.authStateChanges().listen((User? user) async {
                                  CollectionReference costi = await FirebaseFirestore.instance.collection('CostiRifornimento');
                                  //QuerySnapshot costiChart = (FirebaseFirestore.instance.collection('costi').doc('2022').collection('Cost').where('mese', isEqualTo: months[current_month! - 1])) as QuerySnapshot<Object?>;
                                  current_month = now.month;
                                  current_year = now.year;
                                  await FirebaseFirestore.instance.collection('costi').doc('2022').collection('Cost').doc('${months[current_month! - 1]}').update({"costo": FieldValue.increment(costoRifornimento!)});
                                  //.where('mese', isEqualTo: months[current_month! - 1]);
                                  //docRef.update({"costo": FieldValue.increment(costoRifornimento!)});

                                  costi.add({
                                    'costo': costoRifornimento,
                                    'data': date.toString(),
                                    'year': now.year,
                                    'mese': months[current_month! - 1],
                                    'type': 'Rifornimento carburante',
                                    'uid': user?.uid
                                  });




                                  /*
                                  if(costiChart.docs.isNotEmpty) {
                                    await costiChart.docs[0].reference.update({'costo': costoRifornimento});
                                  }
                                   */
                                  /*
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                      builder: (context) => Costi(: costoRifornimento, key: null,),

                                  ));
                                  */
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) => Costi(0)));
                                })
                            },
                  style: ElevatedButton.styleFrom(
                    elevation: 10,
                    backgroundColor: Colors.blue.shade200,
                    shape: const StadiumBorder(),

                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 2,
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
  String? calcoloLitri(){

    double result;

    if(labelLitri == null) {
      labelLitri = '';
    }
    else if(costoAlLitro != null && costoRifornimento != null) {
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


