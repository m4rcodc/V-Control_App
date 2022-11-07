import 'package:car_control/Page/Scadenze.dart';
import 'package:car_control/Page/home_page.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class AddAssicurazione extends StatefulWidget{
  static const routeName = '/add-Assicurazione';

  @override
  State<AddAssicurazione> createState() => _AddAssicurazioneState();
}

class _AddAssicurazioneState extends State<AddAssicurazione> {
  String nome ="";
  String prezzo ="";
  String tipoScad ="";
  //late DateTime dataScad;
  String selectedDate = "Inserisci la data di scadenza";

  DateTime date = DateTime.now();


  final List<String> choiceScad = [
    "Annuale",
    "Semestrale",
    "Trimestrale"
  ];

  final _formKey = GlobalKey<FormState>();

  void _submit(){
    if (_formKey.currentState!.validate()){
      var info = {
        'titolo': 'Assicurazione Auto',
        'nome': nome,
        'prezzo': prezzo,
        'tipoScad': tipoScad,
        'dataScad': date,
      };
      Scadenze.insert(info);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aggiunto con successo'),backgroundColor: Colors.green,),
      );
      HomePage.setPage(Scadenze(), 1);
      Navigator.of(context).pushNamed(HomePage.routeName);
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
                    colors: [Colors.cyan,Colors.lightBlue],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft
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
                  colors: [Colors.lightBlue, Colors.white70],
                )
            ),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 15.0),
                    alignment: Alignment.center,
                    child: Image.asset('images/insurance.png',height: 150,width: 150),
                  ),
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
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder:  OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.indigoAccent),
                          borderRadius: BorderRadius.circular(15),
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
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder:  OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.indigoAccent),
                          borderRadius: BorderRadius.circular(15),
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
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder:  OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.indigoAccent),
                            borderRadius: BorderRadius.circular(15),
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
                      margin: const EdgeInsets.symmetric(vertical: 50.0,horizontal: 60.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 10,
                          backgroundColor: Colors.blue.shade200,
                          shape: const StadiumBorder(),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 6,
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
                                "Aggiungi assicurazione",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
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
