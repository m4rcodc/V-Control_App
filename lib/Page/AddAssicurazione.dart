import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';


class AddAssicurazione extends StatefulWidget{
  static const routeName = '/add-scadenza';

  @override
  State<AddAssicurazione> createState() => _AddAssicurazioneState();
}

class _AddAssicurazioneState extends State<AddAssicurazione> {
  late String nome;
  late String prezzo;
  late String tipoScad;
  late DateTime dataScad;
  String selectedDate = "Inserisci la data di scadenza";

  final List<String> choiceScad = [
    "Annuale",
    "Semestrale",
    "Trimestrale"
  ];

  final _formKey = GlobalKey<FormState>();

  void _submit(){
    if (_formKey.currentState!.validate()){
      print(nome);
      print(prezzo);
      print(tipoScad);
      print(dataScad);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Processing Data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text("Aggiugi Assicurazione"),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          toolbarHeight: 55,
          flexibleSpace: Container(
            decoration:const BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
                gradient: LinearGradient(
                    colors: [Colors.blue,Colors.cyan],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter
                )
            ),
          ),
        ),
        body: Container(
          //padding: EdgeInsets.only(top: 20.0,left: 20.0, right: 20.0),
            decoration:const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.cyan, Colors.white70],
                )
            ),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 15.0),
                    child: TextFormField(
                      onChanged: (value) {
                        setState(() {
                          nome = value;
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        hintText: "Inserisci il nome dell'assicurazione",
                        hintStyle: const TextStyle(fontSize: 14),
                        filled: true,
                        fillColor: Colors.white70,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Inserisci il nome';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 15.0),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          prezzo = value;
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        hintText: "Inserisci il prezzo",
                        hintStyle: const TextStyle(fontSize: 14),
                        filled: true,
                        fillColor: Colors.white70,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Inserisci il prezzo';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 15.0),
                    child: DropdownButtonFormField2(
                      decoration: InputDecoration(
                        //Add isDense true and zero Padding.
                        //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          filled: true,
                          fillColor: Colors.white70
                      ),
                      isExpanded: true,
                      hint: const Text(
                        'Tipologia scadenza',
                        style: TextStyle(fontSize: 14),
                      ),
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black45,
                      ),
                      iconSize: 30,
                      buttonHeight: 60,
                      buttonPadding: const EdgeInsets.only(left: 20, right: 10),
                      dropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      items: choiceScad
                          .map((item) =>
                          DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ))
                          .toList(),
                      validator: (value) {
                        if (value == null) {
                          return 'Seleziona tipologia scadenza';
                        }
                      },
                      onChanged: (value) {
                        tipoScad = value.toString();
                      },
                      onSaved: (value) {
                        tipoScad = value.toString();
                      },
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 15.0),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue
                          ),
                          onPressed: () {
                            /*DatePicker.showDatePicker(context,
                                showTitleActions: true,
                                minTime: DateTime(2000, 1, 1),
                                maxTime: DateTime(2100, 6, 7),
                                onChanged: (date) {
                                  print('change $date');
                                }, onConfirm: (date) {
                                  print(date);
                                  setState(() {
                                    dataScad = date;
                                    selectedDate = " Data : "+DateFormat("dd-MM-yyyy").format(date);
                                  });
                                }, currentTime: DateTime.now(), locale: LocaleType.it);
                          */
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.calendar_month,color: Colors.white,size: 25),
                                Text(
                                  selectedDate,
                                  style: const TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                          )
                      )
                  ),
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 15.0),
                      child: ElevatedButton(
                        child: const Padding(
                          padding: EdgeInsets.all(15),
                          child:Text('Aggiungi'),
                        ),
                        onPressed: () {
                          // It returns true if the form is valid, otherwise returns false
                          _submit();
                        },
                      )
                  )
                ],
              ),
            )

        )
    );
  }
}
