import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:car_control/Widgets/BarraChilometri.dart';
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
  final void Function()? delete;
  bool flagAnimation = false;
  bool _tagliando = false;
  int _km = 0;

  String get title => _title;

  BoxScadenza(titolo,nomeAssic,scadenza,icona,String prezzo,int km,{super.key, required this.pagamento, required this.modifica, this.delete}){ //costruttore assicurazione
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
        _subtitle = strScadenza+"\n"+prezzo+" €";
    }
    else
      _subtitle = nomeAssic+"\n"+strScadenza+"\n"+prezzo+" €";
    print(_title);
    if(_title == 'Tagliando') {
      _tagliando = true;
      _km = km;
    }
    _icona = icona;
  }

  void methodPagamento() async {
    pagamento;
  }



  @override
  Widget build(BuildContext context){
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.020,left: MediaQuery.of(context).size.width * 0.073, right: MediaQuery.of(context).size.width * 0.023),
      child:
      Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(
              color: _coloreBord,
              width: 3
          ),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child:
        Container(
          margin: EdgeInsets.only(top: 8),
          child:
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(
                  _icona,
                  size: 45,
                  color: Colors.blue.shade200,
                ),
                title: Text(_title),
                subtitle: Text(_subtitle),
                trailing:
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF90CAF9),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child:
                  IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed:
                          () {
                        AwesomeDialog(
                            context: context,
                            dialogType: DialogType.warning,
                            headerAnimationLoop: false,
                            animType: AnimType.topSlide,
                            title: 'Attenzione!',
                            desc:
                            'Sicuro di voler procedere con l\'eliminazione?',
                            btnCancelText: 'No',
                            btnOkText: 'Si',
                            btnCancelOnPress: () {},
                            btnOkOnPress:
                            delete
                        ).show();
                      }
                  ),
                ),
              ),
              _tagliando ? BarraChilometri(_km) : Container(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                      onPressed:
                          () {
                        AwesomeDialog(
                            context: context,
                            dialogType: DialogType.warning,
                            headerAnimationLoop: false,
                            animType: AnimType.topSlide,
                            title: 'Vuoi proseguire con l\'aggiunta del pagamento all\'interno della sezione costi?',
                            btnOkText: 'Prosegui',
                            btnCancelText: 'No',
                            btnCancelOnPress: () {},
                            btnOkOnPress:
                              pagamento
                            ,
                        ).show();
                      },

                      child:Row(
                        children: const [
                          Icon(Icons.euro,color: Colors.green,),
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
      ),
    );
  }
}