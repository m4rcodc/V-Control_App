import 'package:car_control/Page/AddAssicurazione.dart';
import 'package:car_control/Page/AddBollo.dart';
import 'package:car_control/Page/AddTagliando.dart';
import 'package:car_control/Page/home_page.dart';
import 'package:car_control/Page/veicolo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../Widgets/BoxScadenza.dart';



class Scadenze extends StatefulWidget {
  static const routeName = '/scadenze';


  static List<AnimationWidget> lista = [
    AnimationWidget(BoxScadenza(
        "Bollo",
        "",
        DateTime(2022,12,14),
        Icons.wallet,
        "210",
        pagamento: (){},
        modifica: (){}
    ),
        false
    ),
    AnimationWidget(BoxScadenza(
        "Assicurazione Auto",
        "Allianz Direct",
        DateTime(2021,02,17),
        Icons.security,
        "470",
        pagamento: (){},
        modifica: (){}
    ),
        false
    )
  ];

  static void insert(var info){
    lista.add(
        AnimationWidget(BoxScadenza(
            info['titolo'],
            info['nome'],
            info['dataScad'],
            Icons.security,
            info['prezzo'],
            pagamento: (){},
            modifica: (){}
        ),
            true
        )
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
  _ScadenzeState createState() => _ScadenzeState(lista);
}

class _ScadenzeState extends State<Scadenze>{
  late List<AnimationWidget> listaScadenze;

  _ScadenzeState(List<AnimationWidget> lista){
    listaScadenze = lista;
  }

  @override
  Widget build(BuildContext context) {
    HomePage.resetPage();
    Scadenze.sortLista();
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
            children: [
              SpeedDialChild(
                child: const Icon(Icons.build),
                backgroundColor: Colors.white70,
                labelStyle: const TextStyle(fontSize: 18.0, color: Colors.white),
                labelBackgroundColor: Colors.lightBlue.shade300,
                label: 'Manutenzione ordinaria',
                //onTap: () => Navigator.of(context).pushNamed(),
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
                onTap: () => Navigator.of(context).pushNamed(AddAssicurazione.routeName),
              ),
            ],
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

  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: const Offset(-1.5, 0.0),
    end: Offset.zero,
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.bounceInOut,
  ));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(_animation){
      return SlideTransition(
        position: _offsetAnimation,
        child: _boxScadenza,
      );
    }
    return Container(
      child: _boxScadenza,
    );
  }
}