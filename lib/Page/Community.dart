
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import '../models/communityModel.dart';



class Community extends StatefulWidget {

  @override
  _CommunityState createState() => _CommunityState();
}

class _CommunityState extends State<Community>{


  int? rank;

  List<CommunityModel> communityProfile = [];


  Stream<List<CommunityModel>> readUserPointsComm() => FirebaseFirestore.instance
      .collection('community')
      .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
      .snapshots()
      .map((snapshot) =>
      snapshot.docs.map((doc) => CommunityModel.fromJson(doc.data())).toList()
  );

  Stream<List<CommunityModel>> readCommunityPoints() {
    return FirebaseFirestore.instance
        .collection('community')
        .orderBy('points', descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => CommunityModel.fromJson(doc.data())).toList()
    );
  }

  List<CommunityModel> commList = [];





  @override
  initState(){
    super.initState();

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
                                padding: EdgeInsets.symmetric(vertical: 2,horizontal:12),
                                children: [
                                  Container(
                                    //padding: EdgeInsets.symmetric(vertical:10, horizontal:10),
                                      alignment: Alignment.topCenter,
                                      child: Text('Classifica', style: TextStyle(fontSize: 20),)
                                  ),
                                  Container(
                                    height: 400, //margin: EdgeInsets.all(20),
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
                                                Text(communityProfile[index].name!)
                                              ],
                                            ),
                                            leading: Text("${index + 1}.",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),),
                                            trailing:
                                            Text(
                                                (communityProfile[index].points.toString()), style: const TextStyle(
                                                fontWeight: FontWeight.bold)),
                                          );
                                        },
                                        separatorBuilder: (context, index) => const Divider(
                                          thickness: 2.5,
                                          color: Colors.white,
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
                              communityProfile[2].image!),
                        ),
                        Container(
                            padding: EdgeInsets.only(top: 6),
                            child:
                            Text(communityProfile[2].name!)
                        ),
                        Container(
                            padding: EdgeInsets.only(top: 4),
                            child:
                            Text(communityProfile[2].points.toString())
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
                              communityProfile[1].image!),
                        ),
                        Container(
                            padding: EdgeInsets.only(top: 6),
                            child:
                            Text(communityProfile[1].name!)
                        ),
                        Container(
                            padding: EdgeInsets.only(top: 4),
                            child:
                            Text(communityProfile[1].points.toString())
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
                              communityProfile[3].image!),
                        ),
                        Container(
                            padding: EdgeInsets.only(top: 6),
                            child:
                            Text(communityProfile[3].name!)
                        ),
                        Container(
                            padding: EdgeInsets.only(top: 4),
                            child:
                            Text(communityProfile[3].points.toString())
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
            onPressed: () => {},
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
                    for(int i = 0; i<communityProfile.length ; i++)
                    {
                      if(communityProfile[i].uid == FirebaseAuth.instance.currentUser?.uid)
                      {
                        count = i;
                        rank = ++i;
                        break;
                      }
                    }

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