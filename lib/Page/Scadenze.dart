import 'package:car_control/Page/AddAssicurazione.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../Widgets/BoxScadenza.dart';


class Scadenze extends StatefulWidget {

  @override
  _ScadenzeState createState() => _ScadenzeState();
}


class _ScadenzeState extends State<Scadenze>{
  @override
  Widget build(BuildContext context) {
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
                  colors: [Colors.blue,Colors.cyan],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter
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
              colors: [Colors.cyan, Colors.white70],
            )
        ),
        child: Center(
            child: ListView(
              children:  [
                BoxScadenza("Assicurazione Auto",
                    "Allianz Direct\nScadenza 14/12/2022",
                    Colors.green,
                    Icons.add_chart_sharp,
                    pagamento: (){},
                    modifica: (){}
                ),
                BoxScadenza("Bollo",
                    "Scaduto\n",
                    Colors.red,
                    Icons.account_balance_wallet,
                    pagamento: (){},
                    modifica: (){}
                )
              ],
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
            child: const Icon(Icons.build,color: Colors.white),
            labelStyle: const TextStyle(fontSize: 22.0),
            backgroundColor: Colors.blue,
            label: 'Manutenzione ordinaria',
            //onTap: () => Navigator.of(context).pushNamed(),
          ),
          SpeedDialChild(
            child: const Icon(Icons.oil_barrel,color: Colors.white),
            backgroundColor: Colors.blue,
            labelStyle: const TextStyle(fontSize: 22.0),
            label: 'Tagliando',
            // onTap: () => Navigator.of(context).pushNamed()
          ),
          SpeedDialChild(
            child: const Icon(Icons.account_balance_wallet,color: Colors.white),
            labelStyle: const TextStyle(fontSize: 22.0),
            backgroundColor: Colors.blue,
            label: 'Bollo',
            // onTap: () => Navigator.of(context).pushNamed(),
          ),
          SpeedDialChild(
            child: const Icon(Icons.add_chart,color: Colors.white),
            labelStyle: const TextStyle(fontSize: 22.0),
            backgroundColor: Colors.blue,
            label: 'Assicurazione',
            onTap: () => Navigator.of(context).pushNamed(AddAssicurazione.routeName),
          ),
        ],
      ),
    );
  }
}