import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'addVeicolo.dart';
import 'veicolo.dart';
import 'Costi.dart';
import 'Mappa.dart';
import 'Scadenze.dart';

class HomePage extends StatefulWidget {

  static const routeName = '/home-page';

  @override
  State<HomePage> createState() => _HomePageState();
}
  class _HomePageState extends State<HomePage> {
    int currentTab = 0;
    String currentRoute = AddVeicolo.routeName;
    final List<Widget> page = [
      Veicolo(),
      Scadenze(),
      Costi(),
      Mappa()

    ];

    final PageStorageBucket bucket = PageStorageBucket();
    Widget currentPage = Veicolo();

    @override
    Widget build(BuildContext context) {
      return Scaffold(
          body: PageStorage(
            child: currentPage,
            bucket: bucket,
          ),
          bottomNavigationBar: Container(
              color: Colors.white70,
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 15),
                  child: GNav(
                    backgroundColor: Colors.white70,
                    color: Colors.lightBlue,
                    activeColor: Colors.white,
                    tabBackgroundColor: Colors.blue.shade300,
                    gap: 8,
                    /*onTabChange: (index) {
                      print(index);
                    },*/
                    padding: const EdgeInsets.all(16),
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
                          icon: Icons.import_contacts,
                          text: 'Scadenze',
                          onPressed: () {
                            setState(() {
                              currentPage = Scadenze();
                            });
                          },
                      ),
                      GButton(
                          icon: Icons.bar_chart,
                          text: 'Costi',
                          onPressed: () {
                            setState(() {
                              currentPage = Costi();
                            });
                          },
                      ),
                      GButton(
                          icon: Icons.place,
                          text: 'Mappa',
                          onPressed: () {
                            setState(() {
                              currentPage = Mappa();
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
