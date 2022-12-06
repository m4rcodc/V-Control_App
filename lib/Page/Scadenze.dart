import 'package:car_control/Page/AddAssicurazione.dart';
import 'package:car_control/Page/AddBollo.dart';
import 'package:car_control/Page/AddTagliando.dart';
import 'package:car_control/Page/home_page.dart';
import 'package:car_control/Page/veicolo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../Widgets/BoxScadenza.dart';
import 'AddRevisione.dart';



class Scadenze extends StatefulWidget {
  static const routeName = '/scadenze';

  static late List<AnimationWidget> lista = [];

  static bool resetAnimation = false;

  static void modifica(String titolo,String nome,String prezzo, Timestamp data,String tipoScad,String notif){
    var info= {
      'nome': nome,
      'titolo': titolo,
      'prezzo': prezzo,
      'data': data,
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

  static String uid = FirebaseAuth.instance.currentUser!.uid;

  static Future<List<AnimationWidget>> getScadenze() async{
    var ref = FirebaseFirestore.instance.collection("scadenze")
        .where('uid',isEqualTo: uid);
    var query = await ref.get();
    for (var queryDocumentSnapshot in query.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      Timestamp timestamp = data['dataScad'];
      lista.add(
          AnimationWidget(
              BoxScadenza(
                data['titolo'],
                data['nome'],
                DateTime.fromMillisecondsSinceEpoch(timestamp.seconds*1000),
                getIcon(data['titolo']),
                data['prezzo'],
                pagamento: (){},
                modifica: () => modifica(data['titolo'],data['nome'],data['prezzo'],timestamp,data['tipoScad'],data['notifiche']),
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
    lista.add(
        AnimationWidget(BoxScadenza(
          info['titolo'],
          info['nome'],
          info['dataScad'],
          getIcon(info['titolo']),
          info['prezzo'],
          pagamento: (){},
          modifica: () => modifica(info['titolo'],info['nome'],info['prezzo'],timestamp,info['tipoScad'],info['notifiche']),
          delete: () => delete(info['titolo']),
        ),
            true
        )
    );

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
            'tipoScad': info['tipoScad'],
            'notifiche': info['notifiche'],
            'uid': uid,
          });
        }
      }
      else {
        scadenze.add({
          'nome': info['nome'],
          'titolo': info['titolo'],
          'dataScad': info['dataScad'],
          'prezzo': info['prezzo'],
          'tipoScad': info['tipoScad'],
          'notifiche': info['notifiche'],
          'uid': uid,
        });
      }
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

  static void delete(String titolo){
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
      CollectionReference scadenze = await FirebaseFirestore.instance.collection('scadenze');
      var ref = scadenze.where('uid',isEqualTo: uid).where('titolo',isEqualTo: titolo);
      var query = await ref.get();
      for(var doc in query.docs){
        doc.reference.delete();
      }
    });
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
}

class _ScadenzeState extends State<Scadenze>{
  static late BuildContext contextScad;

  late List<AnimationWidget> listaScadenze;

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
          SpeedDial(
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
        ],
        title: Text('Scadenze'),
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
                end: Alignment.bottomLeft,
              )
          ),
        ),
      ), /*child:const Center(
            child: Text('Scadenze Screen', style: TextStyle(fontSize: 40)),
          )*/
      body: Container(
        decoration:const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.lightBlue, Colors.white70],
            )
        ),
        child: Center(
            child: ListView(
                children:  listaScadenze
            )
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
    duration: const Duration(seconds: 2),
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