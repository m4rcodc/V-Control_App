import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'addVeicolo.dart';
import 'veicolo.dart';
import 'Costi.dart';
import 'Help.dart';
import 'Scadenze.dart';
import 'Community.dart';



class HomePage extends StatefulWidget {


  static const routeName = '/home-page';

  static Widget paginaIniz = Veicolo();
  static int tabIniz = 0;

  static void setPage(Widget page, int tab){
    paginaIniz = page;
    tabIniz = tab;
  }
  static void resetPage(){
    paginaIniz = Veicolo();
    tabIniz = 0;
  }

  @override
  State<HomePage> createState() => _HomePageState(paginaIniz,tabIniz);

}
class _HomePageState extends State<HomePage> {
  late int currentTab;
  String currentRoute = AddVeicolo.routeName;

  static bool first = true;

  final PageStorageBucket bucket = PageStorageBucket();
  late Widget currentPage;

  _HomePageState(Widget paginaIniz, int tabIniz){
    currentPage = paginaIniz;
    currentTab = tabIniz;
    initScadenze();
  }

  void initScadenze() async{
    if(first){
      print("fetch scadenze");
      await Scadenze.getScadenze();
      first = false;
    }
  }
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
                  selectedIndex: currentTab,
                  backgroundColor: Colors.white70,
                  color: Colors.lightBlue,
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