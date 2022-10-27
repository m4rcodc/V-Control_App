 import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class BoxAddScadenza extends StatelessWidget{

  String _title = "";

   BoxAddScadenza(nome, {super.key}){
    _title = nome;
  }

  @override
  Widget build(BuildContext contex){
     return Listener(
       onPointerDown: (PointerDownEvent p){print(p);},
       child: Container(
         margin: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
         child: DottedBorder(
           color: Colors.black45,//color of dotted/dash line
           strokeWidth: 3, //thickness of dash/dots
           dashPattern: [10,6], //dash patterns, 10 is dash width, 6 is space width
           child: Padding(
               padding: const EdgeInsets.all(28),
               child:Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children:  <Widget>[
                   const Icon(
                     color: Colors.black45,
                     Icons.add_circle_outline,
                   ),
                   Text(_title,
                     textAlign: TextAlign.center,
                     style: const TextStyle(
                         color: Colors.black45,
                         fontSize: 20
                     ),
                   ),
                 ],
               )
           ),
         ),
       ),
     );
  }
}