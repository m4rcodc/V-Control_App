import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class Carburante extends StatefulWidget {


  static const routeName = '/add-carburante';

  @override
  _CarburanteState createState() => _CarburanteState();
}

class _CarburanteState extends State<Carburante>{

  //FocusNode myFocusNode = FocusNode();

  int? costoRifornimento;
  double? costoAlLitro;
  num? litri;
  String? labelLitri;

  DateTime date = DateTime.now();

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
                    hintText: '${date.day}/${date.month}/${date.year}',
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
                        initialDate: date,
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
                   setState(() => date = newDate);
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 18.0,horizontal: 15.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                      costoRifornimento = int.tryParse(value);
                    });
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 18.0,horizontal: 15.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                      /*if(costoAlLitro != null && costoRifornimento != null) {
                        labelLitri = (costoRifornimento! ~/ costoAlLitro!).toString();
                      }
                      else {
                        labelLitri = '0';
                      }*/
                    });
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 18.0,horizontal: 15.0),
                child: TextField(
                  readOnly: true,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
              Container(
                margin: const EdgeInsets.symmetric(vertical: 18.0,horizontal: 15.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
              Container(
                margin: const EdgeInsets.symmetric(vertical: 70.0,horizontal: 90.0),
                child: ElevatedButton(
                  onPressed: () => print("Prova"),
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

    if(labelLitri == null) {
      labelLitri = '';
    }
    else if(costoAlLitro != null && costoRifornimento != null) {
      labelLitri = (costoRifornimento! ~/ costoAlLitro!).toString();
    }

    else {
      labelLitri = '0';
    }

    return labelLitri;
  }
  }


