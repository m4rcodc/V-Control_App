import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Page/Scadenze.dart';

class BarraChilometri extends StatelessWidget{

  static int kmIniz = 0;
  static int kmAttual = Scadenze.kmAttual;
  static int kmFine = 0;
  static double percent = 0.0;
  static String uid = FirebaseAuth.instance.currentUser!.uid;

  BarraChilometri(int km){
    kmFine = km;
    if((kmFine/2)>kmAttual){
      kmIniz = 0;
    }
    else {
      kmIniz = (kmFine/2).round();
    }
    percent = kmAttual/(kmIniz+kmFine);
  }


  static void initKmAttuali() async{
    var ref = FirebaseFirestore.instance.collection("vehicle")
        .where('uid',isEqualTo: uid);
    var query = await ref.get();
    for (var queryDocumentSnapshot in query.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      if(data['kilometers'] != ''){
        kmAttual = data['kilometers'];
      }
    }
}

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 0,horizontal: 30),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.only(bottom: 5),
              child: const Text(
                "Km prossimo tagliando:",style: TextStyle(color: Colors.black54),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: (MediaQuery.of(context).size.width-90)*percent),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.green,
              boxShadow: const [
                BoxShadow(color: Colors.green, spreadRadius: 3),
              ],
            ),
            height: 10,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0)),
                color: Colors.white,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top:5),
            child: Row(
              children:  <Widget>[
                Expanded(
                  child: Text(kmIniz.toString()+' km', textAlign: TextAlign.left,style: TextStyle(fontSize: 12,color: Colors.black54),),
                ),
                Expanded(
                  child: Text(kmFine.toString()+' km', textAlign: TextAlign.right,style: TextStyle(fontSize: 12,color: Colors.black54)),
                ),
              ],
            ),
          )

        ],
      ),
    );
  }

}