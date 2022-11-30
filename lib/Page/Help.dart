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

class _HelpState extends State<Help>{

  final ref = FirebaseFirestore.instance.collection("vehicle").where("uid", isEqualTo:uid).get().then((value){
    fuel = value.docs[0].data()['fuel'];
    if(fuel == 'Elettrica')
    {
      distributore = 'Colonnine di ricarica';
    }
    else if (fuel == 'Metano'){
      distributore = 'Distributori di Metano';
    }
    else{
      distributore = 'Benzinaio';
    }
  });

  final number = '333333333';
  @override
  Widget build(BuildContext context) {
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
                subtitle: Text(number),
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
                            height: 250,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 10,
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)
                                  )
                              ),
                              onPressed: () {
                                _launchRiforn();
                              },
                              child: Padding(
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
                                      child: Icon(
                                        Icons.search,
                                          color: Colors.lightBlue
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
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                            height: 250,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 10,
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)
                                  )
                              ),
                              onPressed: () => {_launchOff()},
                              child: Padding(
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
                                      child: Icon(
                                        Icons.search,
                                          color: Colors.lightBlue
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(vertical:20,horizontal: 0),
                                      child: Text('Trova l\' officina più vicina', style: const TextStyle(
                                        fontSize: 18.0,
                                        color: Color(0xFF1A1316),
                                      ),
                                      ),
                                    ),
                                    Text('Visualizza sulla mappa', style: const TextStyle(
                                      fontSize: 16.0,
                                        color: Colors.blueGrey
                                    )),
                                  ],
                                ),
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

_callNumber() async{
  const number = '08592119XXXX'; //set the number here
  bool? res = await FlutterPhoneDirectCaller.callNumber(number);
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