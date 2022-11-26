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
  double? kmVeicolo;
  double? index = 1;
  late double totalCost;


  DateTime now = new DateTime.now();
  var formatter = new DateFormat('dd-MM-yyyy');

  List months =
  ['gen', 'feb', 'mar', 'apr', 'mag','giu','lug','ago','set','ott','nov','dic'];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.blue.shade300, // <-- SEE HERE
        ),
        title: Text('Nuovo rifornimento',style: TextStyle(color: Colors.blue.shade300)),
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
                width: MediaQuery.of(context).size.width,
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
                      blurRadius: 6,
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

                      //Data
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
                          initialDate: now,
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100),
                          builder: (context,child) {
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
                          Text("Data rifornimento: ${formatter.format(now)}")
                        ],
                      ),
                    )
                ),
                ),
              //Costo
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 15.0),
                child:
                Form(
                  key: _formKeyCosto,
                child:
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    labelText: 'Costo rifornimento',
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
                  validator: (value){
                    if(value == null || value.isEmpty){
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
                margin: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 15.0),
                child:
                Form(
                  key: _formKeyCostoAlLitro,
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    labelText: 'Costo al litro',
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
                  validator: (value){
                    if(value == null || value.isEmpty){
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
                margin: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 15.0),
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
                    labelText: 'Litri',
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
                    focusedBorder:  OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.indigoAccent),
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
              //Chilometri veicolo
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 15.0),
                child:
                Form(
                  key: _formKeyKm,
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
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'Inserisci il costo al litro';
                      }
                      else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                    setState(() {
                      kmVeicolo = double.tryParse(value);
                    });
                  },
                ),
                ),
              ),
              //AddButton
              Container(
                margin: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 100.0),
                child: ElevatedButton(
                  onPressed:
                    () => {
                    if(!_formKeyCosto.currentState!.validate()) {
                    }
                    else if(!_formKeyCostoAlLitro.currentState!.validate()){

                    }
                    else if(!_formKeyKm.currentState!.validate()){

                      }
                    else
                      {
                        FirebaseAuth.instance.authStateChanges().listen((
                            User? user) async {
                          CollectionReference costi = await FirebaseFirestore
                              .instance.collection('CostiRifornimento');
                          //CollectionReference costiTot = await FirebaseFirestore.instance.collection('CostiTotali').doc('2022').collection('Cost').doc();
                          final test = await FirebaseFirestore.instance
                              .collection('CostiTotali').doc('2022').collection(
                              user!.uid).get();
                          final generalCosts = await FirebaseFirestore.instance
                              .collection('CostiGenerali')
                              .doc('2022')
                              .collection(user!.uid)
                              .get();


                          if (test.docs.isEmpty) {
                            final docu = await FirebaseFirestore.instance
                                .collection('CostiTotali')
                                .doc('2022')
                                .collection(user!.uid);
                            for (int i = 0; i < 12; i++) {
                              docu.doc(months[i]).set(
                                  {'mese': months[i],
                                    'costo': 0,
                                    'index': i,
                                  }
                              );
                            }
                          }

                          if (generalCosts.docs.isEmpty) {
                            final docu = await FirebaseFirestore
                                .instance.collection('CostiGenerali')
                                .doc('2022')
                                .collection(user!.uid);
                            for (int i = 0; i < 12; i++) {
                              docu.doc(months[i]).set(
                                  {'mese': months[i],
                                    'costo': 0,
                                    'index': i,
                                  }
                              );
                            }
                          }

                          current_month = now.month;
                          current_year = now.year;

                          /*SaveUserIndexRow.indexingUserRow[user?.uid] = index;
                                  SaveUserIndexRow.indexingUserRow.forEach((key, value) {
                                    print('$key \t $value');
                                  });*/
                          costi.add({
                            'costo': costoRifornimento,
                            'data': formatter.format(now),
                            'year': now.year.toString(),
                            'mese': months[current_month! - 1],
                            'type': 'Rifornimento carburante',
                            'uid': user?.uid,
                            'litri': labelLitri,
                            'costoAlLitro': costoAlLitro,
                            'Kilometri veicolo': kmVeicolo,
                            'index': index,

                          });

                          final doc = await FirebaseFirestore.instance
                              .collection('CostiRifornimento')
                              .where(
                              'mese', isEqualTo: months[current_month! - 1])
                              .where('uid', isEqualTo: user?.uid)
                              .get();
                          var docs = doc.docs;
                          double sum = 0.0;
                          for (int i = 0; i < docs.length; i++) {
                            sum += docs[i]['costo'];
                          }

                          final doc1 = await FirebaseFirestore.instance
                              .collection('CostiGenerali').doc('2022')
                              .collection(user.uid).where(
                              'mese', isEqualTo: months[current_month! - 1])
                              .get();
                          var docs1 = doc1.docs;
                          double sum1 = 0.0;
                          sum1 += docs1[0]['costo'];


                          await FirebaseFirestore.instance.collection(
                              'CostiTotali').doc('2022')
                              .collection(user.uid)
                              .doc('${months[current_month! - 1]}')
                              .update({"costo": sum});

                          await FirebaseFirestore.instance.collection(
                              'CostiGenerali').doc('2022')
                              .collection(user.uid)
                              .doc('${months[current_month! - 1]}')
                              .update({"costo": costoRifornimento! + sum1});


                          /*
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                      builder: (context) => Costi(: costoRifornimento, key: null,),

                                  ));
                                  */
                          Navigator.of(context, rootNavigator: true).pop();
                        }
                        )
                      },
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




