import 'package:car_control/Page/AddAssicurazione.dart';
import 'package:car_control/Page/AddBollo.dart';
import 'package:car_control/Page/AddRevisione.dart';
import 'package:car_control/Page/AddTagliando.dart';
import 'package:car_control/Page/home_page.dart';
import 'package:car_control/Page/veicolo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../Widgets/BoxScadenza.dart';



class Scadenze extends StatefulWidget {
  static const routeName = '/scadenze';

  static late List<AnimationWidget> lista = [];

  static bool resetAnimation = false;

  static String uid = FirebaseAuth.instance.currentUser!.uid;

  static Future<List<AnimationWidget>> getScadenze() async{
    var ref = FirebaseFirestore.instance.collection("scadenze")
        .where('uid',isEqualTo: uid)
    ;
    var query = await ref.get();
    for (var queryDocumentSnapshot in query.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      Timestamp timestamp = data['dataScad'];
      print(data['dataScad']);
      lista.add(
          AnimationWidget(
              BoxScadenza(
                data['titolo'],
                data['nome'],
                DateTime.fromMillisecondsSinceEpoch(timestamp.seconds*1000),
                Icons.security,
                data['prezzo'],
                pagamento: (){},
                modifica: (){},
              ),
              false)
      );
    }
    return lista;
  }

  static void insert(var info){
    IconData icon = Icons.abc;
    if(info['titolo'] == 'Assicurazione') icon = Icons.security;
    if(info['titolo'] == 'Bollo') icon = Icons.wallet;
    if(info['titolo'] == 'Tagliando') icon = Icons.checklist;
    if(info['titolo'] == 'Revisione') icon = Icons.build;

    lista.add(
        AnimationWidget(BoxScadenza(
            info['titolo'],
            info['nome'],
            info['dataScad'],
            icon,
            info['prezzo'],
            pagamento: (){},
            modifica: (){}
        ),
            true
        )
    );

    FirebaseAuth.instance.authStateChanges().listen((User? user) async{
      CollectionReference scadenze = await FirebaseFirestore.instance.collection('scadenze');
      scadenze.add({
        'nome': info['nome'],
        'titolo': info['titolo'],
        'dataScad': info['dataScad'],
        'prezzo': info['prezzo'],
        'tipoScad': info['tipoScad'],
        'uid': uid,
      });
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
    HomePage.resetPage();
    Scadenze.sortLista();
    itemsAddScadenze = [
      SpeedDialChild(
          child: const Icon(Icons.build),
          backgroundColor: Colors.white70,
          labelStyle: const TextStyle(fontSize: 18.0, color: Colors.white),
          labelBackgroundColor: Colors.lightBlue.shade300,
          label: 'Revisione',
          onTap: () => Navigator.of(context).pushNamed(AddRevisione.routeName)
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