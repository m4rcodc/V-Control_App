import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BoxScadenza extends StatelessWidget{

  DateTime _dataoggi = DateTime.now();

  String _title = "";
  String _subtitle = "";
  late Color _coloreBord;
  late DateTime dataScad;
  IconData _icona = Icons.abc_sharp;
  final void Function()? pagamento;
  final void Function()? modifica;
  bool flagAnimation = false;

  BoxScadenza(titolo,nomeAssic,scadenza,icona,String prezzo,{super.key, required this.pagamento, required this.modifica}){ //costruttore assicurazione
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    dataScad = scadenza;
    String strScadenza;
    _title = titolo;
    if(scadenza.compareTo(_dataoggi) < 0){
      _coloreBord = Colors.red;
      strScadenza = "Scaduto il "+formatter.format(scadenza);
    }
    else if(scadenza.difference(_dataoggi).inDays <= DateUtils.getDaysInMonth(_dataoggi.year, _dataoggi.month)){
      _coloreBord = Colors.yellow;
      strScadenza = "Scadenza "+formatter.format(scadenza);
    }
    else{
      _coloreBord = Colors.green;
      strScadenza = "Scadenza "+formatter.format(scadenza);
    }
    if(nomeAssic == ""){
      if(prezzo == "")
        _subtitle = strScadenza;
      else
        _subtitle = strScadenza+"\n"+prezzo+"€";
    }
    else
      _subtitle = nomeAssic+"\n"+strScadenza+"\n"+prezzo+"€";
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
                    onPressed: pagamento,
                    child:Row(
                      children: const [
                        Icon(Icons.monetization_on,color: Colors.green,),
                        Text("Pagamento")
                      ],
                    )
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