import 'package:flutter/material.dart';

class DetailsCostCard extends StatelessWidget {
  final String firstText, secondText;
  final Widget icon;

  const DetailsCostCard({ required this.firstText, required this.secondText, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      elevation: 8,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(
            width: 1.0,
            color: Colors.blue,
          )
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 14.0,
          top: 6,
          bottom: 15,
          right: 16,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
            children: [
              Text(firstText, style: const TextStyle(
              fontSize: 18.0,
              color: Color(0xFF1A1316),
            ),
            ),
            Text(secondText, style: const TextStyle(
              fontSize: 18.0,
              color: Color(0xFF8391A0),
            )),
          ],
        ),
            Spacer(),
            Align(
              alignment: Alignment.topRight,
              child: icon,
            ),

        ],
      ),
      ),
    );
  }
}