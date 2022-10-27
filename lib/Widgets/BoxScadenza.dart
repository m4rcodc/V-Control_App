import 'package:flutter/material.dart';

class BoxScadenza extends StatelessWidget{

  String _title = "";
  String _subtitle = "";
  Color _coloreBord = Colors.green;
  IconData _icona = Icons.abc_sharp;
  final void Function()? dettagli;
  final void Function()? modifica;

  BoxScadenza(titolo,sottotitolo,colore,icona,{super.key, required this.dettagli, required this.modifica}){
    _title = titolo;
    _subtitle = sottotitolo;
    _coloreBord = colore;
    _icona = icona;
  }

  @override
  Widget build(BuildContext context){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15.0,horizontal: 15.0),
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(
              color: _coloreBord,
              width: 3
          ),
          borderRadius: BorderRadius.all(Radius.circular(12)),

        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
             ListTile(
              leading: Icon(
                _icona,
                size: 45,
              ),
              title: Text(_title),
              subtitle: Text(_subtitle),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  onPressed: dettagli,
                  child: const Text('Dettagli'),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: modifica,
                  child: const Text('Modifica'),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}