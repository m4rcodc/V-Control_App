import 'package:car_control/Widgets/DetailsCarCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';

class Help extends StatefulWidget {

  @override
  _HelpState createState() => _HelpState();
}



class _HelpState extends State<Help>{

  final number = '333333333';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text('Help'),
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
          decoration:const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.lightBlue, Colors.white70],
            )
          ),
        child: ListView(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 40.0,horizontal: 22.0),
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
             // margin: const EdgeInsets.symmetric(vertical:0,horizontal: 15),
              alignment: Alignment.center,
              child: Image.asset('images/HelpMap.png',height: 150,width: 280),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 35.0,horizontal: 12.0),
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
                              backgroundColor: Colors.blue.shade200,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)
                              )
                            ),
                              onPressed: () => {},
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
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical:12,horizontal: 0),
                                child: Text('Trova la stazione di rifornimento più vicina', style: const TextStyle(
                                  fontSize: 18.0,
                                  color: Color(0xFF1A1316),
                                ),
                                ),
                                ),
                                Text('Visualizza sulla mappa', style: const TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white60,
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
                                backgroundColor: Colors.blue.shade200,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)
                                )
                            ),
                            onPressed: () => {},
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
                                    color: Colors.white60,
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
        )
        ),
    );
  }
}

_callNumber() async{
  const number = '08592119XXXX'; //set the number here
  bool? res = await FlutterPhoneDirectCaller.callNumber(number);
}