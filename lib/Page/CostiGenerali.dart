import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:d_chart/d_chart.dart';
import 'package:tap_to_expand/tap_to_expand.dart';

class CostiGenerali extends StatefulWidget{

  @override
  CostiGeneraliState createState() => CostiGeneraliState();
}

class CostiGeneraliState extends State<CostiGenerali>{

  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  final streamChart = FirebaseFirestore.instance.collection('CostiGenerali')
      .doc('2022').collection(FirebaseAuth.instance.currentUser!.uid).orderBy('index', descending: false)
      .snapshots(includeMetadataChanges: true);

  Widget build(BuildContext context) {

    return Scaffold(
      body:
      Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.lightBlue, Colors.white],
            )
        ),

        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 200, horizontal: 10),
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: StreamBuilder(
                  stream: streamChart,
                  builder: (context, AsyncSnapshot<
                      QuerySnapshot<Map<String, dynamic>>> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }
                    if (snapshot.data == null) {
                      //return const Text("Empty");
                      return Center(child: CircularProgressIndicator());
                    }
                    List<Map<String, dynamic>> listChart = snapshot.data!.docs
                        .map((e) {
                      return {
                        'domain': e.data()['mese'],
                        'measure': e.data()['costo'],
                      };
                    }).toList();
                    return AspectRatio(
                      aspectRatio: 16 / 9,
                      child: DChartBar(
                        data: [
                          {
                            'id': 'Bar',
                            'data': listChart,
                          },
                        ],
                        axisLineColor: Colors.white70,
                        barColor: (barData, index, id) => Colors.white70,
                        showBarValue: true,
                      ),
                    );
                  }
              ),
            ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 0),
                child:
                TapToExpand(
                  color: Colors.blue,
                  content: Column(
                    children: <Widget> [
                        /*Text(
                          "data",
                          style: const TextStyle(color: Colors.white, fontSize: 20),
                        ),*/
                    ],
                  ),
                  title: const Text(
                    'TapToExpand',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  onTapPadding: 10,
                  closedHeight: 70,
                  //scrollable: true,
                  borderRadius: 10,
                  openedHeight: 150,
                )
                ),
          ],
        ),
      ),
    );
  }




}