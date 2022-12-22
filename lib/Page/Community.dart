import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/communityModel.dart';

String? modelV;
String infoPunteggioRifornimento = "L'assegnazione del punteggio mediante rifornimento seguirà le seguenti regole ed avverrà ogni 100km percorsi.\n"
                                   "La soglia di riferimento è 2 litri, se l'utente si troverà dopo 100 km percorsi al di sotto di tale soglia\n"
    "gli verranno assegnati 10 punti, viceversa gli verranno sottratti 8 punti dallo score. ";
class Community extends StatefulWidget {

  @override
  _CommunityState createState() => _CommunityState();
}

class _CommunityState extends State<Community>{


  int? rank;

  List<String> namePodium = [];
  List<int> pointsPodium = [];
  List<String> imagePodium = [];


  List<CommunityModel> communityProfile = [];




  Stream<List<CommunityModel>> readCommunityPoints() {
    debugPrint(modelV);
    if(modelV == ' ')
      {
        return FirebaseFirestore.instance
            .collection('community')
            .orderBy('points', descending: true)
            .snapshots()
            .map((snapshot) =>
            snapshot.docs.map((doc) => CommunityModel.fromJson(doc.data())).toList()
        );
      }else{
      return FirebaseFirestore.instance
          .collection('community').where('model', isEqualTo: modelV)
          .orderBy('points', descending: true)
          .snapshots()
          .map((snapshot) =>
          snapshot.docs.map((doc) => CommunityModel.fromJson(doc.data())).toList()
      );
    }

  }

  List<CommunityModel> commList = [];


  @override
  initState() {
    super.initState();
  }

  getModelV() async {
    final prefs = await SharedPreferences.getInstance();

    modelV = prefs.getString('modelV') ?? ' ';

  }


  Widget buildCommunity(CommunityModel comm) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
            //height: 300,
            height: MediaQuery.of(context).size.height * 0.40,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.cyan,Color(0xFF90CAF9)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(35),
                  bottomLeft: Radius.circular(35)
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueGrey,
                  blurRadius: 10.0,
                  spreadRadius: 0.0,
                  offset: Offset(
                      2.0, 2.0), // shadow direction: bottom right
                )
              ],
            ),
            child:
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Image(
                      image: AssetImage('images/imageLeft.png'),
                      height: 105,
                      width: 105,
                    ),
                    Stack(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(comm.image!),
                          radius: 50,
                        ),
                      ],
                    ),
                    const Image(
                      image: AssetImage('images/imageRight.png'),
                      height: 105,
                      width: 105,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  '${comm.name}',
                  style: const TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Divider(
                  thickness: 1,
                  indent: 20,
                  endIndent: 20,
                  color: Colors.white,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text("Monete",
                            style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        Row(
                          children: [
                            const Image(
                              image: AssetImage('images/Coin.png'),
                              height: 35,
                              width: 35,
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            Text(
                              "${comm.points}",
                              style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white.withOpacity(0.9)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text("Rank",
                            style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        Row(
                          children: [
                            const Image(
                              image: AssetImage('images/RankIcon.png'),
                              height: 35,
                              width: 35,
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            Text(
                              rank.toString(),
                              style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white.withOpacity(0.9)),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Image(
                    image: AssetImage('images/podium.png'),
                    height: 35,
                    width: 35,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      //border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.lightBlue.shade200,
                    ),
                    child:
                    Container(
                      padding: EdgeInsets.all(10),
                      child:
                      const Text(
                          "Classifica",
                          style: TextStyle(
                              fontSize: 20, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Image(
                    image: AssetImage('images/podium.png'),
                    height: 35,
                    width: 35,
                  ),
                ],
              ),
              Stack(
                children:[
                  Container(
                      margin: EdgeInsets.only(left: 300),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20.0),
                              bottomLeft: Radius.circular(20.0),
                              topLeft: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0)
                          ),
                          //border: Border.all(color: Colors.blueAccent,width: 2),
                          color: Colors.cyan.shade400,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black54,
                                blurRadius: 4.0,
                                offset: Offset(0,3)
                            ),
                          ]
                      ),
                      child: IconButton(
                          onPressed: () {
                            AwesomeDialog(
                              context: context,
                              headerAnimationLoop: false,
                              dialogType: DialogType.noHeader,
                              padding: EdgeInsets.zero,
                              dialogBackgroundColor: Colors.blue.shade200,
                              body:
                              ListView(
                                shrinkWrap: true,
                                padding: EdgeInsets.symmetric(vertical: 15,horizontal:20),
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(bottom: 20),
                                  child:
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Image(
                                        image: AssetImage('images/podium.png'),
                                        height: 35,
                                        width: 35,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          //border: Border.all(color: Colors.white),
                                          borderRadius: BorderRadius.circular(20),
                                          color: Colors.lightBlue.shade200,
                                        ),
                                        child:
                                        Container(
                                          padding: EdgeInsets.all(10),
                                          child:
                                          const Text(
                                              "Classifica",
                                              style: TextStyle(
                                                  fontSize: 20, color: Colors.white)),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const Image(
                                        image: AssetImage('images/podium.png'),
                                        height: 35,
                                        width: 35,
                                      ),
                                    ],
                                  ),
                                  ),
                                  Container(
                                    height: 400,
                                    //margin: EdgeInsets.all(20),
                                    padding: EdgeInsets.symmetric(vertical:10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(25),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black54,
                                          blurRadius: 6.0,
                                        ),
                                      ],
                                    ),
                                    child: ListView.separated(
                                        padding: const EdgeInsets.only(
                                            top: 12, left: 12, right: 12),
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            title: Row(
                                              children: [
                                                CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                      communityProfile[index].image!),
                                                ),
                                                SizedBox(
                                                  width: 3,
                                                ),
                                                Text(communityProfile[index].name!, style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500),)
                                              ],
                                            ),
                                            leading: Text("${index + 1}.",
                                              style: const TextStyle(
                                                  color: Colors.black54, fontWeight: FontWeight.w500),),
                                            trailing:
                                            Text(
                                                (communityProfile[index].points.toString()), style: const TextStyle(
                                                color: Colors.black54, fontWeight: FontWeight.w500)),
                                          );
                                        },
                                        separatorBuilder: (context, index) => const Divider(
                                          thickness: 2.5,
                                          color: Color(0xFF90CAF9),
                                          indent: 10,
                                          endIndent: 10,),
                                        itemCount: communityProfile.length),
                                  ),
                                ],
                              ),
                            ).show();
                          },
                          color: Colors.white,
                          icon: const Icon(
                              Icons.search
                          ))
                  ),
                  Container(
                    //padding: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                    margin: EdgeInsets.only(left: 50, top: 55),
                    child:
                    Column(
                      children:[
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              imagePodium[1]),
                        ),
                        Container(
                            padding: EdgeInsets.only(top: 6),
                            child:
                            Text( namePodium[1])
                        ),
                        Container(
                            padding: EdgeInsets.only(top: 4),
                            child:
                            Text(pointsPodium[1].toString())
                        )
                      ],
                    ),
                  ),
                  Container(
                    //padding: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                    margin: EdgeInsets.only(left: 156, top: 25),
                    child:
                    Column(
                      children:[
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                             imagePodium[0]),
                        ),
                        Container(
                            padding: EdgeInsets.only(top: 6),
                            child:
                            Text(namePodium[0])
                        ),
                        Container(
                            padding: EdgeInsets.only(top: 4),
                            child:
                            Text(pointsPodium[0].toString())
                        )
                      ],
                    ),
                  ),
                  Container(
                    //padding: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                    margin: EdgeInsets.only(left: 255, top: 65),
                    child:
                    Column(
                      children:[
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              imagePodium[2]),
                        ),
                        Container(
                            padding: EdgeInsets.only(top: 6),
                            child:
                            Text(namePodium[2])
                        ),
                        Container(
                            padding: EdgeInsets.only(top: 4),
                            child:
                            Text(pointsPodium[2].toString())
                        )
                      ],
                    ),
                  ),
                  Container(
                    //padding: EdgeInsets.symmetric(vertical: 0),
                      margin: EdgeInsets.only(top: 75),
                      child: Image.asset('images/PodiumImage.png', scale: 1.5)
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    getModelV();

    return Scaffold(
      //extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Community",
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () => {
            AwesomeDialog(
            context: context,
            headerAnimationLoop: false,
            dialogType: DialogType.noHeader,
            padding: EdgeInsets.zero,
            dialogBackgroundColor: Colors.blue.shade200,
            body:
            Container(
            height: 550,
            child:
            Column(
            children: [
            Container(
            //padding: EdgeInsets.symmetric(vertical:10, horizontal:10),
            alignment: Alignment.topCenter,
            child: Text('📙 Info Community ❤', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500),)
            ),
              Container(
                  padding: EdgeInsets.symmetric(vertical:10, horizontal: 32),
                  child: Text('N.B: la classifica visualizza solo gli utenti con lo stesso modello di veicolo. ', style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,)
              ),
              Container(
                  padding: EdgeInsets.symmetric(vertical:15, horizontal:4),
                  //alignment: Alignment.topCenter,
                  child: Text('Modalità di punteggio:', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500),)
              ),
              Container(
                height: 400,
                width: 280,
                padding: EdgeInsets.symmetric(vertical:15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(25),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 6.0,
                    ),
                  ],
                ),
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                    children: [
                      //Tipologia Veicolo
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          //border: Border.all(width: 1, color: Colors.red),
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          color: Colors.blue.shade200,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueGrey,
                              blurRadius: 3.0,
                              //spreadRadius: 0.0,
                              //offset: Offset(-2.0, 2.0,), // shadow direction: bottom right
                            )
                          ],
                        ),
                          child:
                          Text('Tipologia di veicolo', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500), textAlign: TextAlign.center,),
                      ),
                      //Benzina
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        child:
                      Row(
                        children: [
                          Container(
                            child:
                              Image.asset('images/Benzina.png', scale: 6)
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                              child:
                              Text('Benzina:', style: TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.w500))
                          ),
                          SizedBox(
                            width: 72,
                          ),
                          Container(
                              child:
                              Image.asset('images/Coin.png', scale: 12)
                          ),
                          Container(
                              child:
                              Text('100', style: TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.w500))
                          ),

                        ],
                      ),


                      ),
                      //Diesel
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                        child:
                        Row(
                          children: [
                            Container(
                                child:
                                Image.asset('images/Diesel.png', scale: 5)
                            ),
                            SizedBox(
                              width: 13,
                            ),
                            Container(
                                child:
                                Text('Diesel:', style: TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.w500))
                            ),
                            SizedBox(
                              width: 86,
                            ),
                            Container(
                                child:
                                Image.asset('images/Coin.png', scale: 12)
                            ),
                            Container(
                                child:
                                Text('100', style: TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.w500))
                            ),

                          ],
                        ),


                      ),
                      //Gas
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                        child:
                        Row(
                          children: [
                            Container(
                                child:
                                Image.asset('images/GasMetano.png', scale: 5.5,)
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Container(
                                child:
                                Text('Gas:', style: TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.w500))
                            ),
                            SizedBox(
                              width: 104,
                            ),
                            Container(
                                child:
                                Image.asset('images/Coin.png', scale: 12)
                            ),
                            Container(
                                child:
                                Text('150', style: TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.w500))
                            ),

                          ],
                        ),


                      ),
                      //Metano
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                        child:
                        Row(
                          children: [
                            Container(
                                child:
                                Image.asset('images/GasMetano.png', scale:5.5,)
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Container(
                                child:
                                Text('Metano:', style: TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.w500))
                            ),
                            SizedBox(
                              width: 74,
                            ),
                            Container(
                                child:
                                Image.asset('images/Coin.png', scale: 12)
                            ),
                            Container(
                                child:
                                Text('200', style: TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.w500))
                            ),

                          ],
                        ),


                      ),
                      //Elettrica
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                        child:
                        Row(
                          children: [
                            Container(
                                child:
                                Image.asset('images/Elettrica.png', scale:5.8,)
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                                child:
                                Text('Elettrica:', style: TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.w500))
                            ),
                            SizedBox(
                              width: 73,
                            ),
                            Container(
                                child:
                                Image.asset('images/Coin.png', scale: 12)
                            ),
                            Container(
                                child:
                                Text('500', style: TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.w500))
                            ),

                          ],
                        ),


                      ),
                      //Ibrida
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                        child:
                        Row(
                          children: [
                            Container(
                                child:
                                Image.asset('images/Ibrida.png', scale:6,)
                            ),
                            SizedBox(
                              width: 9,
                            ),
                            Container(
                                child:
                                Text('Ibrida:', style: TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.w500))
                            ),
                            SizedBox(
                              width: 85,
                            ),
                            Container(
                                child:
                                Image.asset('images/Coin.png', scale: 12)
                            ),
                            Container(
                                child:
                                Text('300', style: TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.w500))
                            ),

                          ],
                        ),


                      ),
                      //Tipologia Manutenzioni
                      Container(
                        //padding: EdgeInsets.symmetric(vertical:15),
                        margin: EdgeInsets.symmetric(vertical:10),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          //border: Border.all(width: 1, color: Colors.red),
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          color: Colors.blue.shade200,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueGrey,
                              blurRadius: 3.0,
                              //spreadRadius: 0.0,
                              //offset: Offset(-2.0, 2.0,), // shadow direction: bottom right
                            )
                          ],
                        ),
                        child:
                        Text('Tipologia di manutenzione', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
                      ),
                      //Cambio Gomme
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        child:
                        Row(
                          children: [
                            Container(
                                child:
                                Image.asset('images/wheel.png', scale: 12)
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                                child:
                                Text('Cambio gomme:', style: TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.w500))
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Container(
                                child:
                                Image.asset('images/Coin.png', scale: 12)
                            ),
                            Container(
                                child:
                                Text('100', style: TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.w500))
                            ),

                          ],
                        ),


                      ),
                      //Cambio olio
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        child:
                        Row(
                          children: [
                            Container(
                                child:
                                Image.asset('images/oil.png', scale: 12)
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                                child:
                                Text('Cambio olio:', style: TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.w500))
                            ),
                            SizedBox(
                              width: 47,
                            ),
                            Container(
                                child:
                                Image.asset('images/Coin.png', scale: 12)
                            ),
                            Container(
                                child:
                                Text('50', style: TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.w500))
                            ),

                          ],
                        ),


                      ),
                      //Cambio batteria
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        child:
                        Row(
                          children: [
                            Container(
                                child:
                                Image.asset('images/battery.png', scale: 12)
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                                child:
                                Text('Cambio batteria:', style: TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.w500))
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Container(
                                child:
                                Image.asset('images/Coin.png', scale: 12)
                            ),
                            Container(
                                child:
                                Text('50', style: TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.w500))
                            ),

                          ],
                        ),


                      ),
                      //Motore
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        child:
                        Row(
                          children: [
                            Container(
                                child:
                                Image.asset('images/Engine.png', scale: 12)
                            ),
                            SizedBox(
                              width: 11,
                            ),
                            Container(
                                child:
                                Text('Motore:', style: TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.w500))
                            ),
                            SizedBox(
                              width: 84,
                            ),
                            Container(
                                child:
                                Image.asset('images/Coin.png', scale: 12)
                            ),
                            Container(
                                child:
                                Text('100', style: TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.w500))
                            ),

                          ],
                        ),


                      ),
                      //Impianto frenante
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        child:
                        Row(
                          children: [
                            Container(
                                child:
                                Image.asset('images/Brakes.png', scale: 12)
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                                child:
                                Text('Impianto frenante:', style: TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.w500))
                            ),
                            SizedBox(
                              width: 1,
                            ),
                            Container(
                                child:
                                Image.asset('images/Coin.png', scale: 12)
                            ),
                            Container(
                                child:
                                Text('150', style: TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.w500))
                            ),

                          ],
                        ),


                      ),
                      //Altro
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        child:
                        Row(
                          children: [
                            Container(
                                child:
                                Image.asset('images/OtherMaintenance.png', scale: 12)
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                                child:
                                Text('Altro:', style: TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.w500))
                            ),
                            SizedBox(
                              width: 107,
                            ),
                            Container(
                                child:
                                Image.asset('images/Coin.png', scale: 12)
                            ),
                            Container(
                                child:
                                Text('5', style: TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.w500))
                            ),

                          ],
                        ),


                      ),
                      //Punteggio dai rifornimenti
                      Container(
                        margin: EdgeInsets.symmetric(vertical:10),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          //border: Border.all(width: 1, color: Colors.red),
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          color: Colors.blue.shade200,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueGrey,
                              blurRadius: 3.0,
                              //spreadRadius: 0.0,
                              //offset: Offset(-2.0, 2.0,), // shadow direction: bottom right
                            )
                          ],
                        ),
                        child:
                        Text('Rifornimenti', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500), textAlign: TextAlign.center,),
                      ),
                      //Modalità assegnazione punteggio rifornimenti
                      Container(
                        margin: EdgeInsets.symmetric(vertical:10),
                        child:
                          Text("L'assegnazione del punteggio mediante rifornimento seguirà le seguenti regole ed avverrà ogni 100km percorsi.\n"
                              "La soglia di riferimento è 2 litri, se l'utente si troverà dopo 100 km percorsi al di sotto di tale soglia"
                              "gli verranno assegnati 10 punti, viceversa gli verranno sottratti 8 punti dallo score. ", style: TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.w500))
                      )
                    ],

              ),
              )
            ],
            ),
            ),
            ).show()
            }, //end
          )
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Colors.cyan,
          ),
        ),
      ),
      body:
      Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.center,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF90CAF9), Colors.white],
            )
        ),
        child: ListView(
          //physics: NeverScrollableScrollPhysics(),
          children: [

            StreamBuilder<List<CommunityModel>>(
                stream: readCommunityPoints(),
                builder: (context,snapshot) {
                  if (snapshot.hasData) {
                    final comm = snapshot.data!;

                    communityProfile = comm.toList();
                    int count = 0;
                    debugPrint(communityProfile.length.toString());
                    for(int i = 0; i<communityProfile.length ; i++)
                    {
                      if(communityProfile[i].uid == FirebaseAuth.instance.currentUser?.uid)
                      {
                        count = i;
                        rank = ++i;
                        break;
                      }
                    }

                    int j = 3;

                    for(int i = 0; i<communityProfile.length ; i++)
                      {
                        namePodium.add(communityProfile[i].name ?? 'empty');
                        pointsPodium.add(communityProfile[i].points ?? 0);
                        imagePodium.add(communityProfile[i].image ?? '');
                        j--;
                      }
                    for(;j>0;j--)
                      {
                        namePodium.add('empty');
                        pointsPodium.add(0);
                        imagePodium.add('https://firebasestorage.googleapis.com/v0/b/emad2022-23.appspot.com/o/defaultImage%2FLogoApp.png?alt=media&token=815b924d-e981-4fb6-ad76-483a2f591310');
                      }

                    debugPrint("count è $count");
                    List<CommunityModel> singleProfile = [];
                    singleProfile.add(communityProfile[count]);
                    return Column(
                      children: singleProfile.map(buildCommunity).toList(),
                    );
                  }
                  else{
                    return Center(child: CircularProgressIndicator());
                  }
                }

            ),


          ],
        ),


      ),
    );


  }
}