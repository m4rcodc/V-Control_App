import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class DotBorder extends StatelessWidget{

  String _title = "";
  final void Function(PointerDownEvent)? attachedFunction;

   DotBorder(nome ,{super.key, required this.attachedFunction}){
    _title = " "+nome;
  }

  @override
  Widget build(BuildContext context){
     return Listener(
       onPointerDown: attachedFunction,
       child: Container(
         margin: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 15.0),
         child: DottedBorder(
           borderType: BorderType.RRect,
           radius: const Radius.circular(12),
           color: Colors.black54,//color of dotted/dash line
           strokeWidth: 3, //thickness of dash/dots
           dashPattern: const [8,5], //dash patterns, 10 is dash width, 6 is space width
           child: Padding(
               padding: const EdgeInsets.all(28),
               child:Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children:  <Widget>[
                   const Icon(
                     color: Colors.black54,
                     Icons.add_circle_outline,
                     size: 26,

                   ),
                   Text(_title,
                     textAlign: TextAlign.center,
                     style: const TextStyle(
                         color: Colors.black54,
                         fontSize: 20,
                          fontWeight: FontWeight.w600
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