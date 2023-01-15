import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'addVeicolo.dart';
import 'veicolo.dart';
import 'Costi.dart';
import 'Help.dart';
import 'Scadenze.dart';
import 'Community.dart';
import 'AddAssicurazione.dart';

class HomePage extends StatefulWidget {

  static const routeName = '/home-page';

  static Widget paginaIniz = Veicolo();
  static int tabIniz = 0;
  static Map<String,String> stringNotifiche = {};

  static void setPage(Widget page, int tab){
    paginaIniz = page;
    tabIniz = tab;
  }
  static void resetPage(){
    paginaIniz = Veicolo();
    tabIniz = 0;
  }

  static Future<List<String>> getNotifiche() async{
    List<String> lista = [];
    String usiliare = '';
    var ref = FirebaseFirestore.instance.collection("scadenze")
        .where('uid',isEqualTo: uid);
    var query = await ref.get();
    for (var queryDocumentSnapshot in query.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      if(data['notifiche'] != ''){
        Map<String,String> map = {
          data['titolo']: data['notifiche'],
        };
        stringNotifiche.addAll(map);
        print('ciao '+stringNotifiche.toString());
        Timestamp dataScad = data['dataScad'];
        usiliare = data['titolo'] + '-' + dataScad.seconds.toString() + ':' + data['notifiche'];
        lista.add(usiliare);
      }
    }
    return lista;
  }

  @override
  State<HomePage> createState() => _HomePageState(paginaIniz,tabIniz);

}
class _HomePageState extends State<HomePage> {
  late int currentTab;
  String currentRoute = AddVeicolo.routeName;

  static bool first = true;

  static List<String> dateScadenza = [];

  final PageStorageBucket bucket = PageStorageBucket();
  late Widget currentPage;

  _HomePageState(Widget paginaIniz, int tabIniz){
    currentPage = paginaIniz;
    currentTab = tabIniz;
    initScadenze();
  }

  void showNotif(String titolo,Color colore,bool scaduto,String notifica){
    String text;
    Color textColor = Colors.blue;
    if(scaduto){
      textColor = Colors.white;
      if(titolo == "Assicurazione" || titolo == "Revisione") {
        text = 'Attenzione la tua ' +titolo+' è scaduto';
      }
      else {
        text = "Attenzione il tuo "+titolo+" è scaduto";
      }
    }
    else{
      if(titolo == "Assicurazione" || titolo == "Revisione") {
        text = 'Attenzione la tua ' +titolo+' sta per scadere';
      }
      else {
        text = "Attenzione il tuo "+titolo+" sta per scadere";
      }
    }
    showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      transitionDuration: Duration(milliseconds: 1500),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return GestureDetector(
          onVerticalDragUpdate: (dragUpdateDetails) {
            Navigator.of(context).pop();
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 100,horizontal: 20),
            child: Column(
                children: [Card(
                  color: colore,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.announcement_outlined,size: 45,color: Colors.black,),
                        title: Text(text,
                          style: TextStyle(fontSize: 22, color: Colors.black),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                            child: Text('Portami lì',
                              style: TextStyle(fontSize: 20,color: textColor),
                            ),
                            onPressed: () {
                              HomePage.setPage(Scadenze(), 1);
                              Navigator.of(context).popAndPushNamed(HomePage.routeName);
                            },
                          ),
                          TextButton(
                            child: Text('Non mostrare più',
                              style: TextStyle(fontSize: 20,color: textColor),
                            ),
                            onPressed: () async{
                              String notif = HomePage.stringNotifiche[titolo]!;
                              String newNotif = '';
                              for(String str2 in notif.split(',')){
                                if(str2 != notifica){
                                  newNotif += str2;
                                }
                              }
                              HomePage.stringNotifiche[titolo] = newNotif;
                              print('new: '+newNotif);
                                print('sono in HomePage');
                                CollectionReference scadenze = await FirebaseFirestore.instance.collection('scadenze');
                                var ref = scadenze.where('uid',isEqualTo: FirebaseAuth.instance.currentUser?.uid).where('titolo',isEqualTo: titolo);
                                var query = await ref.get();
                                for (var doc in query.docs) {
                                  await doc.reference.update({
                                    'notifiche': newNotif,
                                  });
                                }
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      )

                    ],
                  ),
                ),]
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: anim1.drive(Tween(
              begin: Offset(1, 0), end: Offset(0, 0))
              .chain(CurveTween(curve: Sprung()))),
          child: child,
        );
      },
    );
  }

  void initScadenze() async{
    if(first){
      DateTime dataoggi = DateTime.now();
      dateScadenza = await HomePage.getNotifiche();
      for(int i=0;i<dateScadenza.length;i++){
        List<String> temp = dateScadenza[i].split(':');
        String titolo = temp[0].split('-')[0];
        DateTime dataScad = DateTime.fromMillisecondsSinceEpoch(int.parse(temp[0].split('-')[1])*1000);
        List<String> virgole = temp[1].split(',');
        for(int j=0;j<virgole.length;j++){
          List<String> scad = virgole[j].split('-');
          int val = int.parse(scad[0]);
          String durata = scad[1];
          print(titolo+' '+dataScad.toString()+' '+val.toString()+' '+durata);

          if(dataScad.difference(dataoggi).inDays <= 0){
            showNotif(titolo,Colors.red,true,val.toString()+'-'+durata);
          }
          else{
            if(durata == 'ora' || durata == 'ore'){
              if(dataScad.difference(dataoggi).inHours < val){
                showNotif(titolo,Colors.yellow,false,val.toString()+'-'+durata);
              }
            }
            if(durata == 'giorno' || durata == 'giorni'){
              if(dataScad.difference(dataoggi).inDays < val){
                showNotif(titolo,Colors.yellow,false,val.toString()+'-'+durata);
              }
            }
            if(durata == 'settimana' || durata == 'settimane'){
              if(dataScad.difference(dataoggi).inDays < val*7){
                showNotif(titolo,Colors.yellow,false,val.toString()+'-'+durata);
              }
            }
            if(durata == 'mese' || durata == 'mesi'){
              if(dataScad.difference(dataoggi).inDays < val*30){
                showNotif(titolo,Colors.yellow,false,val.toString()+'-'+durata);
              }
            }
          }
        }
      }
      print("fetch scadenze");
      await Scadenze.getScadenze();
      await Scadenze.getKmAttual();
      await AddAssicurazione.getAssic();
      first = false;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        body: PageStorage(
          child: currentPage,
          bucket: bucket,
        ),
        bottomNavigationBar: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
              color: Color(0xFFE3F2FD),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0,-3),
                  blurRadius: 8,
                  color: Colors.black12,
                )
              ],
            ),
            //color: Colors.yellow,
            child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 10),
                child: GNav(
                  selectedIndex: currentTab,
                  backgroundColor: Colors.transparent,
                  color: Colors.blue,
                  activeColor: Colors.white,
                  tabBackgroundColor: Colors.blue.shade300,
                  gap: 5,
                  /*onTabChange: (index) {
                      print(index);
                    },*/
                  padding: const EdgeInsets.all(12),
                  tabs: [
                    GButton(
                      icon: Icons.directions_car,
                      text: 'Veicolo',
                      onPressed: () {
                        setState(() {
                          currentPage = Veicolo();
                        });
                      },
                    ),
                    GButton(
                      //gap: 2,
                      icon: Icons.import_contacts,
                      text: 'Scadenze',
                      onPressed: () {
                        setState(() {
                          currentPage = Scadenze();
                        });
                      },
                    ),
                    GButton(
                      icon: Icons.sports_esports,
                      text: 'Game',
                      onPressed: () {
                        setState(() {
                          currentPage = Community();
                        });
                      },
                    ),
                    GButton(
                      icon: Icons.bar_chart,
                      text: 'Costi',
                      onPressed: () {
                        setState(() {
                          currentPage = Costi(0);
                        });
                      },
                    ),
                    GButton(
                      icon: Icons.contact_support,
                      text: 'Help',
                      onPressed: () {
                        setState(() {
                          currentPage = Help();
                        });
                      },
                    ),

                  ],
                )
            )
        )

    );
  }
}

class Sprung extends Curve {
  factory Sprung([double damping = 20]) => Sprung.custom(damping: damping);

  Sprung.custom({
    double damping = 20,
    double stiffness = 180,
    double mass = 1.0,
    double velocity = 0.0,
  }) : this._sim = SpringSimulation(
    SpringDescription(
      damping: damping,
      mass: mass,
      stiffness: stiffness,
    ),
    0.0,
    1.0,
    velocity,
  );

  final SpringSimulation _sim;

  @override
  double transform(double t) => _sim.x(t) + t * (1 - _sim.x(1.0));
}