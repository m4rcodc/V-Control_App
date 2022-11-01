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


  static List<Widget> lista = [
    BoxScadenza(
        "Bollo",
        "Scaduto\n",
        Colors.red,
        Icons.account_balance_wallet,
        pagamento: (){},
        modifica: (){}
    ),
    BoxScadenza(
        "Assicurazione Auto",
        "Allianz Direct\nScadenza 14/12/2022",
        Colors.green,
        Icons.add_chart_sharp,
        pagamento: (){},
        modifica: (){}
    ),
  ];

  static void insert(var info){
    lista.add(
        AnimationWidget(BoxScadenza(
            info['titolo'],
            info['nome'],
            Colors.green,
            Icons.add_chart_sharp,
            pagamento: (){},
            modifica: (){}
        ))
    );
  }

  @override
  _ScadenzeState createState() => _ScadenzeState(lista);
}

class _ScadenzeState extends State<Scadenze>{
  late List<Widget> listaScadenze;

  _ScadenzeState(List<Widget> lista){
    listaScadenze = lista;
  }

  @override
  Widget build(BuildContext context) {
    HomePage.resetPage();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: (){},
          )
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
      floatingActionButton: SpeedDial(
        spaceBetweenChildren: 15.0,
        icon: Icons.add,
        activeIcon: Icons.arrow_downward,
        renderOverlay: false,
        elevation: 8.0,
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
    );
  }
}

class AnimationWidget extends StatefulWidget {
  late BoxScadenza box;
  AnimationWidget(BoxScadenza boxScadenza, {super.key}){
    box = boxScadenza;
  }

  @override
  State<AnimationWidget> createState() => _AnimationWidgetState(box);
}

class _AnimationWidgetState extends State<AnimationWidget> with SingleTickerProviderStateMixin{

  late BoxScadenza _boxScadenza;
  _AnimationWidgetState(BoxScadenza box){
    _boxScadenza = box;
  }

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
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
    return SlideTransition(
      position: _offsetAnimation,
      child: _boxScadenza,
    );
  }
}