import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class Autolavaggio extends StatefulWidget {


  static const routeName = '/add-autolavaggio';

  @override
  _AutolavaggioState createState() => _AutolavaggioState();
}

class _AutolavaggioState extends State<Autolavaggio>{

  DateTime date = DateTime.now();
  double? costoAutolavaggio;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title:const  Text('Autolavaggio'),
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
              margin: const EdgeInsets.symmetric(horizontal: 15.0),
              alignment: Alignment.center,
              child: Image.asset('images/ImageCarWash.png',height: 300,width: 300,),
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
                  labelText: 'Costo autolavaggio',
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
                onChanged: (value) {
                  setState(() {
                    costoAutolavaggio = double.tryParse(value);
                  });
                },
              ),
            ),
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
                    //await FirebaseFirestore.instance.collection('users').doc.set({'nome': name, 'cognome': surname, 'email' : email});
                    CollectionReference costi = await FirebaseFirestore.instance.collection('costi');
                    //await FirebaseFirestore.instance.collection('vehicle').doc(user?.uid).set({'uid': user?.uid, 'make': carMake, 'model' : carMakeModel, 'plate': plate});
                    // Call the user's CollectionReference to add a new user
                    costi.add({
                      'costo': costoAutolavaggio,
                      'data': date,
                      'type': 'Autolavaggio',
                      'uid': user?.uid, // John Doe
                    });

                    /*Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const LoadingScreen()),
                                  );
                                  */
                    /*
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Veicolo aggiunto con successo'), backgroundColor: Colors.lightBlue,  )
                                  );
                                  */
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
}



