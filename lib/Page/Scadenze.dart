import 'dart:async';

import 'package:car_control/Page/AddAssicurazione.dart';
import 'package:car_control/Page/AddBollo.dart';
import 'package:car_control/Page/AddTagliando.dart';
import 'package:car_control/Page/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import '../Widgets/BoxScadenza.dart';
import 'AddRevisione.dart';
import 'package:timelines/timelines.dart';




class Scadenze extends StatefulWidget {
  static const routeName = '/scadenze';

  static late List<AnimationWidget> lista = [];
  static int kmAttual = 1;
  static bool resetAnimation = false;

  static String uid = FirebaseAuth.instance.currentUser!.uid;

  static void modifica(String titolo,String nome,String prezzo,int km ,Timestamp data,String tipoScad,String notif){
    var info= {
      'nome': nome,
      'titolo': titolo,
      'prezzo': prezzo,
      'data': data,
      'km': km,
      'tipoScad': tipoScad,
      'notifiche': notif
    };
    String route = '';
    if(titolo == 'Assicurazione') {
      route = AddAssicurazione.routeName;
      AddAssicurazione.info = info;
    }
    if(titolo == 'Bollo') {
      route = AddBollo.routeName;
      AddBollo.info = info;
    }
    if(titolo == 'Tagliando') {
      route = AddTagliando.routeName;
      AddTagliando.info = info;
    }
    if(titolo == 'Revisione') {
      route = AddRevisione.routeName;
      AddRevisione.info = info;
    }
    Navigator.of(_ScadenzeState.contextScad).pushNamed(route);
  }

  static pagamento(String titolo,String nome,String prezzo,int km ,Timestamp data,String tipoScad,String notif) async{
    List months =
    ['gen', 'feb', 'mar', 'apr', 'mag','giu','lug','ago','set','ott','nov','dic'];
    int? current_month;
    int? current_year;
    DateTime now = new DateTime.now();
    int indexMonth = now.month;
    String month = months[indexMonth - 1];
    var formatter = new DateFormat('dd-MM-yyyy');
    current_year = now.year;
    print('anno $current_year');

    CollectionReference costiScadenze = await FirebaseFirestore
        .instance.collection('CostiScadenze');
    final doc = await FirebaseFirestore.instance
        .collection('CostiScadenze')
        .where(
        'mese', isEqualTo: month)
        .where('uid', isEqualTo: uid)
        .get();
    var docs = doc.docs;
    double sum = 0.0;
    for (int i = 0; i < docs.length; i++) {
      sum += docs[i]['costoScadenza'];
    }
    final generalCosts = await FirebaseFirestore.instance
        .collection('CostiGenerali')
        .doc('$current_year')
        .collection(uid!)
        .get();
    final test = await FirebaseFirestore.instance
        .collection('CostiTotaliScadenze').doc('$current_year').collection(
        uid!).get();
    if (generalCosts.docs.isEmpty) {
      final docu = await FirebaseFirestore
          .instance.collection('CostiGenerali')
          .doc('$current_year')
          .collection(uid!);
      for (int i = 0; i < 12; i++) {
        docu.doc(months[i]).set(
            {'mese': months[i],
              'costo': 0,
              'index': i,
              'totaleLitri': 0,
            }
        );
      }
    }
    if (test.docs.isEmpty) {
      final docu = await FirebaseFirestore.instance
          .collection('CostiTotaliScadenze')
          .doc('$current_year')
          .collection(uid!);
      for (int i = 0; i < 12; i++) {
        docu.doc(months[i]).set(
            {'mese': months[i],
              'costoScadenza': 0,
              'index': i,
            }
        );
      }
    }

    costiScadenze.add({
      'costoScadenza': double.tryParse(prezzo),
      'data': formatter.format(now),
      'year': now.year.toString(),
      'mese': month,
      'uid': uid,
      'tipo': titolo
    });

    final doc1 = await FirebaseFirestore.instance
        .collection('CostiGenerali').doc('$current_year')
        .collection(uid!).where(
        'mese', isEqualTo: month)
        .get();
    var docs1 = doc1.docs;
    double sum1 = 0.0;
    sum1 += docs1[0]['costo'];

    await FirebaseFirestore.instance.collection(
        'CostiTotaliScadenze').doc('$current_year')
        .collection(uid!)
        .doc('${month}')
        .update({"costoScadenza": sum + double.tryParse(prezzo)!});

    await FirebaseFirestore.instance.collection(
        'CostiGenerali').doc('$current_year')
        .collection(uid!)
        .doc('${month}')
        .update({"costo": double.tryParse(prezzo)! + sum1});

    deleteAfterPay(titolo);
    if(tipoScad != ""){
      print("data: ");print(data);
      DateTime dataScad = DateTime.fromMillisecondsSinceEpoch(data.millisecondsSinceEpoch);
      DateTime newDataScad = DateTime.now();
      if(tipoScad == "Trimestrale"){
        newDataScad = new DateTime(dataScad.year,dataScad.month+3,dataScad.day);
      }
      if(tipoScad == "Semestrale"){
        newDataScad = new DateTime(dataScad.year,dataScad.month+6,dataScad.day);
      }
      if(tipoScad == "Annuale"){
        newDataScad = new DateTime(dataScad.year+1,dataScad.month,dataScad.day);
      }
      var info= {
        'nome': nome,
        'titolo': titolo,
        'prezzo': prezzo,
        'dataScad': newDataScad,
        'km': km,
        'tipoScad': tipoScad,
        'notifiche': notif
      };
      insert(info, false);

    }

  }

  static Future<String> getKmAttual() async{
    var ref = FirebaseFirestore.instance.collection("vehicle")
        .where('uid',isEqualTo: uid);
    var query = await ref.get();
    for (var queryDocumentSnapshot in query.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      kmAttual = data['kilometers'];
    }
    return '';
  }

  static Future<List<AnimationWidget>> getScadenze() async{
    var ref = FirebaseFirestore.instance.collection("scadenze")
        .where('uid',isEqualTo: uid);
    var query = await ref.get();
    for (var queryDocumentSnapshot in query.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      Timestamp timestamp = data['dataScad'];
      int km = 0;
      if(data['titolo'] == 'Tagliando') km = data['km'];
      var info= {
        'nome': data['nome'],
        'titolo': data['titolo'],
        'prezzo': data['prezzo'],
        'data': timestamp,
        'km': km,
        'tipoScad': data['tipoScad'],
        'notifiche': data['notifiche']
      };
      lista.add(
          AnimationWidget(
              BoxScadenza(
                data['titolo'],
                data['nome'],
                DateTime.fromMillisecondsSinceEpoch(timestamp.seconds*1000),
                getIcon(data['titolo']),
                data['prezzo'],
                km,
                pagamento: () => pagamento(data['titolo'],data['nome'],data['prezzo'],km,timestamp,data['tipoScad'],data['notifiche']),
                modifica: () => modifica(data['titolo'],data['nome'],data['prezzo'],km,timestamp,data['tipoScad'],data['notifiche']),
                delete: () => delete(data['titolo']),
              ),
              false)
      );
    }
    return lista;
  }

  static IconData getIcon(String titolo){
    IconData icon = Icons.abc;
    if(titolo == 'Assicurazione') icon = Icons.security;
    if(titolo == 'Bollo') icon = Icons.wallet;
    if(titolo == 'Tagliando') icon = Icons.checklist;
    if(titolo == 'Revisione') icon = Icons.build;

    return icon;
  }

  static void insert(var info,bool mod){
    Timestamp timestamp = Timestamp.fromDate(info['dataScad']);
    int km = 0;
    if(info['titolo'] == 'Tagliando') {
      km = info['km'];
    }
    lista.add(
        AnimationWidget(BoxScadenza(
          info['titolo'],
          info['nome'],
          info['dataScad'],
          getIcon(info['titolo']),
          info['prezzo'],
          km,
          pagamento: () => pagamento(info['titolo'],info['nome'],info['prezzo'],km,timestamp,info['tipoScad'],info['notifiche']),
          modifica: () => modifica(info['titolo'],info['nome'],info['prezzo'],km,timestamp,info['tipoScad'],info['notifiche']),
          delete: () => delete(info['titolo']),
        ),
            true
        )
    );

    Timer _timer = Timer(Duration(seconds: 5), (){
      FirebaseAuth.instance.authStateChanges().listen((User? user) async{
        CollectionReference scadenze = await FirebaseFirestore.instance.collection('scadenze');
        if(mod){
          var ref = scadenze.where('uid',isEqualTo: uid).where('titolo',isEqualTo: info['titolo']);
          var query = await ref.get();
          for (var doc in query.docs) {
            await doc.reference.update({
              'nome': info['nome'],
              'titolo': info['titolo'],
              'dataScad': info['dataScad'],
              'prezzo': info['prezzo'],
              'km': km,
              'tipoScad': info['tipoScad'],
              'notifiche': info['notifiche'],
              'uid': uid,
              'numero': info['numero']
            });
          }
        }
        else {
          scadenze.add({
            'nome': info['nome'],
            'titolo': info['titolo'],
            'dataScad': info['dataScad'],
            'prezzo': info['prezzo'],
            'km': km,
            'tipoScad': info['tipoScad'],
            'notifiche': info['notifiche'],
            'uid': uid,
            'numero': info['numero']
          });
        }
      });
    });


  }

  static void update(var info,String old) async{
    AnimationWidget? oldScad = search(old);
    if(oldScad != null){
      lista.remove(oldScad);
      insert(info,true);
    }
  }

  static AnimationWidget? search(String titolo){
    for(int i=0;i<lista.length;i++){
      if(lista[i].box.title == titolo) {
        return lista[i];
      }
    }
    return null;
  }

  static void delete(String titolo) async{
    if(titolo == 'Assicurazione') AddAssicurazione.info = null;
    if(titolo == 'Bollo') AddBollo.info = null;
    if(titolo == 'Revisione') AddRevisione.info = null;
    if(titolo == 'Tagliando') AddTagliando.info = null;

    AnimationWidget? deleted = search(titolo);
    if(deleted != null){
      lista.remove(deleted);
      HomePage.setPage(Scadenze(), 1);
      Navigator.pushReplacement(
          _ScadenzeState.contextScad,
          MaterialPageRoute(
              builder: (BuildContext context) => HomePage()));
    }

    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      CollectionReference scadenze = await FirebaseFirestore.instance
          .collection('scadenze');
      var ref = scadenze.where('uid', isEqualTo: uid).where(
          'titolo', isEqualTo: titolo);
      var query = await ref.get();
      for (var doc in query.docs) {
        doc.reference.delete();
      }
    }
      );
  }

  static void deleteAfterPay(String titolo){
    if(titolo == 'Assicurazione') AddAssicurazione.info = null;
    if(titolo == 'Bollo') AddBollo.info = null;
    if(titolo == 'Revisione') AddRevisione.info = null;
    if(titolo == 'Tagliando') AddTagliando.info = null;

    AnimationWidget? deleted = search(titolo);
    if(deleted != null){
      lista.remove(deleted);
      HomePage.setPage(Scadenze(), 1);
      Navigator.pushReplacement(
          _ScadenzeState.contextScad,
          MaterialPageRoute(
              builder: (BuildContext context) => HomePage()));
    }

    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      CollectionReference scadenze = await FirebaseFirestore.instance
          .collection('scadenze');
      var ref = scadenze.where('uid', isEqualTo: uid).where(
          'titolo', isEqualTo: titolo);
      var query = await ref.get();
      for (var doc in query.docs) {
        doc.reference.delete();
      }
    }
    );
  }

  static void sortLista(){
    var repeat = true;
    var temp;
    int count;
    while(repeat){
      count = 0;
      for(var i=0;i<lista.length-1;i++){
        if(lista[i].box.dataScad.compareTo(lista[i+1].box.dataScad)>0){
          temp = lista[i];
          lista[i] = lista[i+1];
          lista[i+1] = temp;
          count++;
        }
      }
      if(count == 0) {
        repeat = false;
      }
    }
  }

  @override
  _ScadenzeState createState() => _ScadenzeState(lista,resetAnimation);

  static var contextS = null;

  }


class _ScadenzeState extends State<Scadenze>{
  static late BuildContext contextScad;

  late List<AnimationWidget> listaScadenze;
  var state;

  String? uid = FirebaseAuth.instance.currentUser!.uid;

  checkCar() async {
    final doc =  await FirebaseFirestore.instance
        .collection('vehicle')
        .where('uid', isEqualTo: uid)
        .get();
    if(doc.docs.isNotEmpty){
      state = true;
      print(state);
    }
    else {
      state = false;
      print(state);
    }
  }

  @override
  initState() {
    super.initState();
    checkCar();
  }

  _ScadenzeState(lista,resetAnimation) {
    listaScadenze = lista;
    if(resetAnimation){
      for(var box in listaScadenze){
        if(box.box.flagAnimation){
          box._animation = false;
          box.box.flagAnimation = false;
        }
      }
      Scadenze.resetAnimation = false;
    }

    for(var box in listaScadenze){
      if(box._animation == true){
        box.box.flagAnimation = true;
        Scadenze.resetAnimation = true;
      }
    }
  }

  List<SpeedDialChild> itemsAddScadenze = [];

  @override
  Widget build(BuildContext context) {
    contextScad = context;
    Scadenze.contextS = context;
    HomePage.resetPage();
    Scadenze.sortLista();
    itemsAddScadenze = [
      SpeedDialChild(
        child: const Icon(Icons.build),
        backgroundColor: Colors.white70,
        labelStyle: const TextStyle(fontSize: 18.0, color: Colors.white),
        labelBackgroundColor: Colors.lightBlue.shade300,
        label: 'Revisione',
        onTap: () => Navigator.of(context).pushNamed(AddRevisione.routeName),
      ),
      SpeedDialChild(
          child: const Icon(Icons.checklist),
          backgroundColor: Colors.white70,
          labelStyle: const TextStyle(fontSize: 18.0, color: Colors.white),
          labelBackgroundColor: Colors.lightBlue.shade300,
          label: 'Tagliando',
          onTap: () => Navigator.of(context).pushNamed(AddTagliando.routeName)
      ),
      SpeedDialChild(
        child: const Icon(Icons.payments),
        backgroundColor: Colors.white70,
        labelStyle: const TextStyle(fontSize: 18.0, color: Colors.white),
        labelBackgroundColor: Colors.lightBlue.shade300,
        label: 'Bollo',
        onTap: () => Navigator.of(context).pushNamed(AddBollo.routeName),
      ),
      SpeedDialChild(
        child: const Icon(Icons.security),
        backgroundColor: Colors.white70,
        labelStyle: const TextStyle(fontSize: 18.0, color: Colors.white),
        labelBackgroundColor: Colors.lightBlue.shade300,
        label: 'Assicurazione',
        onTap: ()async =>
        {
          await AddAssicurazione.getAssic(),
          Navigator.of(context).pushNamed(AddAssicurazione.routeName)
        },
      ),
    ];

    for(int i=0;i<listaScadenze.length;i++){
      for(int j=0;j<itemsAddScadenze.length;j++){
        if(listaScadenze[i].box.title == itemsAddScadenze[j].label){
          itemsAddScadenze.removeAt(j);
        }
      }
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
             child: SpeedDial(
              foregroundColor: Colors.white,
              backgroundColor: Colors.transparent,
              direction: SpeedDialDirection.down,
              spaceBetweenChildren: 15.0,
              icon: Icons.add,
              activeIcon: Icons.keyboard_arrow_up,
              renderOverlay: true,
              elevation: 0,
              shape: CircleBorder(),
              children: itemsAddScadenze,
            ),

             )
    ],
        title: Text('Scadenze', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 10.0,
        toolbarHeight: 50,
        flexibleSpace: Container(
          decoration:const BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
              gradient: LinearGradient(
                colors: [Colors.cyan,Color(0xFF90CAF9)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )
          ),
        ),
      ), /*child:const Center(
            child: Text('Scadenze Screen', style: TextStyle(fontSize: 40)),
          )*/
      body:
      Container(
        decoration:const BoxDecoration(
            color: Color(0xFFE3F2FD)
        ),
        child:
        Stack(
            children: [
               Timeline.tileBuilder(
                  padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.91, top: MediaQuery.of(context).size.height * 0.11),
                    builder: TimelineTileBuilder.fromStyle(
                      contentsAlign: ContentsAlign.basic,
                      contentsBuilder: (context, index) => Padding(
                        padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.18, bottom: 20),
                      ),
                      itemCount: 4,
                      indicatorStyle: IndicatorStyle.dot,
                      connectorStyle: ConnectorStyle.solidLine
                      ),
                      theme: TimelineThemeData(
                        color: Colors.blue.shade500
                      ),
                    ),
              ListView(
                children:
                listaScadenze,
            )
          ],
      ),
      ),
    );
  }
}

class AnimationWidget extends StatefulWidget {
  late BoxScadenza box;
  late bool _animation;
  AnimationWidget(BoxScadenza boxScadenza, this._animation,{super.key}){
    box = boxScadenza;
  }

  @override
  State<AnimationWidget> createState() => _AnimationWidgetState(box,_animation);
}

class _AnimationWidgetState extends State<AnimationWidget> with SingleTickerProviderStateMixin{

  late BoxScadenza _boxScadenza;
  late bool _animation;
  _AnimationWidgetState(BoxScadenza box, animation){
    _boxScadenza = box;
    this._animation = animation;
  }


  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  )..forward();

  late final Animation<double> _animazione = CurvedAnimation(
    parent: _controller,
    curve: Curves.bounceInOut,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(_animation){
      return ScaleTransition(
        scale:_animazione,
        child: _boxScadenza,
      );
    }
    return Container(
      child: _boxScadenza,
    );
  }

}