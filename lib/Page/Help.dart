import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';

class Help extends StatefulWidget {

  @override
  _HelpState createState() => _HelpState();
}

String? fuel;
String? distributore;
String? uid = FirebaseAuth.instance.currentUser?.uid;
var number;

class _HelpState extends State<Help> {

  String? numero = '';
  var state;


  final ref = FirebaseFirestore.instance.collection("vehicle").where("uid", isEqualTo: FirebaseAuth.instance.currentUser?.uid).get().then((value){
    fuel = value.docs[0].data()['fuel'];
    if(fuel == 'Elettrica')
    {
      distributore = 'Colonnine di ricarica';
    }
    else if (fuel == 'Metano'){
      distributore = 'Distributori di Metano';
    }
    else if (fuel == 'Gas'){
      distributore = 'Distributore di Gas';
    }
    else{
      distributore = 'Benzinaio';
    }
  });

   /*checkNumber()  async{
    await FirebaseFirestore.instance.collection("scadenze").where("uid", isEqualTo:uid).where("titolo", isEqualTo: 'Assicurazione').get().then((value) {
      setState(() {
        numero = value.docs[0].data()['numero'];
      });
    });
  }*/

  checkNumber() async{
    print('Sono qui');
    final doc =  await FirebaseFirestore.instance
        .collection('scadenze')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .where("titolo", isEqualTo: 'Assicurazione')
        .get();
    if(doc.docs.isNotEmpty){
      setState(() {
        numero = doc.docs[0]['numero'];
      });
    }
    else {
      setState(() {
        numero = '';
      });
    }
    //print(numero);
  }

    checkCar() async {
      final doc =  await FirebaseFirestore.instance
          .collection('vehicle')
          .where('uid', isEqualTo:FirebaseAuth.instance.currentUser?.uid)
          .get();
      if(doc.docs.isNotEmpty){
        state = true;
        //print(state);
      }
      else {
        state = false;
        //print(state);
      }
    }

  @override
  initState() {
    super.initState();
    checkNumber();
    checkCar();
  }

  @override
  Widget build(BuildContext context) {
    _callNumber() async{
       if(numero! == ''){
         return AwesomeDialog(
           context: context,
           dialogType: DialogType.error,
           headerAnimationLoop: false,
           //animType: AnimType.topSlide,
           //transitionAnimationDuration: Duration(microseconds: 50),
           title: 'Attenzione!',
           desc:
           'Prima di poter effettuare una chiamata di emergenza, inserisci le informazioni relative alla tua assicurazione!',
           btnOkOnPress: () {

           },
         ).show();
       }
       else {
         await FlutterPhoneDirectCaller.callNumber(numero!);
       }
    }
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
        title: Text('Help', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 10.0,
        toolbarHeight: 50,
      ),
      body: Container(
        decoration:const BoxDecoration(
            color: Color(0xFFE3F2FD)
        ),
        child:
        Container(
          padding: EdgeInsets.all(20),
          child:
          Image.asset(
            'images/HelpImage.png',
            height: 370,
            width: MediaQuery.of(context).size.width,
            scale: 1.75,
          ),
        ),
      ),
      bottomSheet: Container(
        decoration: const BoxDecoration(
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
        height: MediaQuery.of(context).size.height * 0.64,
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(top: 0),
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 25.0,horizontal: 22.0),
              decoration: BoxDecoration(
                  color: Colors.white70,
                  border: Border.all(width: 2, color: Colors.white70),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5.0,
                        offset: Offset(0,5)
                    ),
                    BoxShadow(
                        color: Colors.white70,
                        offset: Offset(-5,0)
                    ),
                    BoxShadow(
                        color: Colors.white70,
                        offset: Offset(5,0)
                    )
                  ]
              ),
              child: ListTile(
                title: Text('Numero di emergenza assicurazione'),
                subtitle: Text('$numero'),
                leading: Icon(
                  Icons.sos,
                  size: 40,
                  color: Colors.redAccent,
                ),
                trailing: TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal:18, vertical:12),
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      side: BorderSide(color: Colors.green),
                    ),
                  ),
                  child: Text('Chiama', style: TextStyle(color: Colors.white),),
                  onPressed: _callNumber,
                ),
              ),
            ),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 12.0),
                child: Table(
                  children: [
                    TableRow(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                            decoration: BoxDecoration(
                                color: Colors.transparent
                              ),
                            height: 250,
                            child: ElevatedButton(
                              clipBehavior: Clip.antiAlias,
                              style: ElevatedButton.styleFrom(
                                  elevation: 10,
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)
                                  ),
                                padding: EdgeInsets.zero,
                              ),
                              onPressed: () {
                                if(state == false){
                                   AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.error,
                                    headerAnimationLoop: false,
                                    //animType: AnimType.topSlide,
                                    //transitionAnimationDuration: Duration(microseconds: 50),
                                    title: 'Attenzione!',
                                    desc:
                                    'Inserisci un veicolo!',
                                    btnOkOnPress: () {
                                    },
                                  ).show();
                                }
                                else {
                                  _launchRiforn();
                                }
                              },
                              child:
                              Stack(
                                fit: StackFit.expand,
                                //alignment: Alignment.center,
                                children: [
                                  Image.asset('images/BackgroundMappe.png', fit: BoxFit.cover,  opacity: const AlwaysStoppedAnimation(0.5),),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 14.0,
                                  top: 18,
                                  bottom: 15,
                                  right: 16,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Container(
                                        decoration: BoxDecoration(
                                        color: Color(0xFF90CAF9),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                  child:
                                      IconButton(
                                        icon: Icon(Icons.search, color: Colors.white),
                                        onPressed: () {
                                          if(state == false){
                                            AwesomeDialog(
                                              context: context,
                                              dialogType: DialogType.error,
                                              headerAnimationLoop: false,
                                              //animType: AnimType.topSlide,
                                              //transitionAnimationDuration: Duration(microseconds: 50),
                                              title: 'Attenzione!',
                                              desc:
                                              'Inserisci un veicolo!',
                                              btnOkOnPress: () {
                                              },
                                            ).show();
                                          }
                                          else {
                                            _launchRiforn();
                                          }
                                        },
                                      ),
                                   ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(vertical:12,horizontal: 0),
                                      child: Text('Trova la stazione di rifornimento più vicina',
                                        style: const TextStyle(
                                          fontSize: 18.0,
                                          color: Color(0xFF1A1316),
                                        ),
                                      ),

                                    ),
                                    Text('Visualizza sulla mappa', style: const TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.blueGrey,
                                    )),
                                  ],
                                ),
                              ),
                             ],
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                            decoration: BoxDecoration(
                                color: Colors.transparent
                            ),
                            height: 250,
                            child: ElevatedButton(
                              clipBehavior: Clip.antiAlias,
                              style: ElevatedButton.styleFrom(
                                elevation: 10,
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)
                                ),
                                padding: EdgeInsets.zero,
                              ),
                              onPressed: () {
                                  _launchOff();
                              },
                              child:
                              Stack(
                                fit: StackFit.expand,
                                //alignment: Alignment.center,
                                children: [
                                  Image.asset('images/BackgroundMappe.png', fit: BoxFit.cover,  opacity: const AlwaysStoppedAnimation(0.5),),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 14.0,
                                      top: 18,
                                      bottom: 15,
                                      right: 16,
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Align(
                                          alignment: Alignment.topLeft,
                                         child: Container(
                                            decoration: BoxDecoration(
                                              color: Color(0xFF90CAF9),
                                              borderRadius: BorderRadius.circular(25),
                                            ),
                                            child:
                                            IconButton(
                                              icon: Icon(Icons.search, color: Colors.white),
                                              onPressed: () {
                                                _launchOff();
                                              },
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(vertical:12,horizontal: 0),
                                          child: Text('Trova l\' officina più vicina',
                                            style: const TextStyle(
                                              fontSize: 18.0,
                                              color: Color(0xFF1A1316),
                                            ),
                                          ),

                                        ),
                                        Text('Visualizza sulla mappa', style: const TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.blueGrey,
                                        )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]
                    ),

                  ],
                )
            ),
          ],
        ),
      ),
    );
  }
}


_launchRiforn() async{

  var url = "https://www.google.com/maps/search/?api=1&query=${distributore}";


  final Uri _url = Uri.parse(url);

  await launchUrl(_url,mode: LaunchMode.externalApplication);
}


_launchOff() async {

  const url = "https://www.google.com/maps/search/?api=1&query=meccanico";
  final Uri _url = Uri.parse(url);

  await launchUrl(_url,mode: LaunchMode.externalApplication);
}