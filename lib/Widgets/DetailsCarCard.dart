import 'package:flutter/material.dart';

class DetailsCarCard extends StatelessWidget {
  final String firstText, secondText;
  final Widget icon;

  const DetailsCarCard({ required this.firstText, required this.secondText, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      color: Colors.blue.shade50,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        /*side: const BorderSide(
          width: 1.0,
          color: Colors.blue,
        )*/
      ),

      child: Padding(
        padding: const EdgeInsets.only(
          left: 14.0,
          top: 6,
          bottom: 15,
          right: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: icon,
            ),
            Text(firstText, style: const TextStyle(
              fontSize: 18.0,
              color: Color(0xFF1A1316),
            ),
          ),
            Text(secondText, style: const TextStyle(
              fontSize: 16.0,
              color: Color(0xFF8391A0),
            )),
          ],
        ),
      ),
    );
  }
}