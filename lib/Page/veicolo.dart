import 'package:car_control/Page/addVeicolo.dart';
import 'package:car_control/Widgets/DetailsCarCard.dart';
import 'package:flutter/material.dart';



class Veicolo extends StatefulWidget {

  @override
  _VeicoloState createState() => _VeicoloState();
}

class _VeicoloState extends State<Veicolo>{


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
      title:const  Text('Veicolo'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        //toolbarHeight: 55,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: ()  => Navigator.of(context).pushNamed(AddVeicolo.routeName),
          )
        ],
        /*flexibleSpace: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
              gradient: LinearGradient(
                  colors: [Colors.cyan,Colors.lightBlue],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft
              )
          ),
        ),*/
      ),
          body:
          Container(
               decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [Colors.lightBlue, Colors.white],
                        )
                    ),
          child: ListView(
            children: [
              Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height - 80.0,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.transparent,
                  ),
                  Positioned(
                    top: 75.0,
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(45.0),
                          topRight: Radius.circular(45.0),
                        ),
                          color: Colors.white60,
                      ),
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                  Positioned(
                    top: 30.0,
                    left: (MediaQuery.of(context).size.width /2) - 86.0,
                    child: const CircleAvatar(
                      radius: 91.0,
                      backgroundColor: Colors.cyan,
                      child: CircleAvatar(
                        radius: 85.0,
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage('images/audi-rs3-primo-contatto-2021-12_01.jpg')
                      )
                      ,
                    ),
                  ),
                  Positioned(
                    top: 230,
                    left: 10,
                    right: 10,
                    child: Table(
                      children:  [
                        TableRow(
                          children: [
                            DetailsCarCard(
                                firstText: "Marca",
                                secondText: "Fiat",
                              icon: Image.asset(
                                "images/car-search-icon.png",
                                width: 40,
                                color: Colors.lightBlue,
                              ),
                            ),
                            DetailsCarCard(
                                firstText: "Modello",
                                secondText: "Abarth",
                              icon: Image.asset(
                                "images/modello-auto-icon.png",
                                width: 40,
                                color: Colors.lightBlue ,
                              ),
                            ),

                          ]
                        ),
                         TableRow(
                            children: [
                              DetailsCarCard(
                                  firstText: "Alimentazione",
                                  secondText: "Benzina",
                                icon: Image.asset(
                                  "images/fuel-pump-icon.png",
                                  width: 40,
                                  color: Colors.lightBlue ,
                                ),
                              ),
                              DetailsCarCard(
                                  firstText: "Cilindrata",
                                  secondText: "1200",
                                icon: Image.asset(
                                  "images/engine-auto-icon.png",
                                  width: 40,
                                  color: Colors.lightBlue ,
                                ),
                              ),

                            ]
                        ),
                        TableRow(
                            children: [
                              DetailsCarCard(
                                  firstText: "Km attuali",
                                  secondText: "150000",
                                icon: Image.asset(
                                  "images/tachimetro-icon.png",
                                  width: 40,
                                  color: Colors.lightBlue ,
                                ),

                              ),
                              DetailsCarCard(
                                  firstText: "Targa",
                                  secondText: "XVC767",
                                icon: Image.asset(
                                  "images/license-plate-icon.png",
                                  width: 40,
                                  color: Colors.lightBlue ,
                                ),
                              ),

                            ]
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          ),
    );
  }
    }

