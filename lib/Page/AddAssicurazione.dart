import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:car_control/Page/Scadenze.dart';
import 'package:car_control/Page/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BoxNotifica extends StatefulWidget{
  late int value;
  late String time;
  void Function()? remove;

  BoxNotifica(String testo, int num, {super.key,required this.remove}){
    time = testo;
    value = num;
  }
  @override
  State<BoxNotifica> createState() => _BoxNotificaState(time,value,remove);
}

class _BoxNotificaState extends State<BoxNotifica>{
  late String _testoNotifica;
  final void Function()? remove;
  _BoxNotificaState(String time, int num, this.remove){
    _testoNotifica = "$num $time prima";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 0,horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            color: Colors.white,
              onPressed: remove,
              icon: Icon(Icons.close)),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                  Radius.circular(25)),
              color: Colors.white,
            ),
            child:
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child:
            Text(
            _testoNotifica,
            style: const TextStyle(
                fontSize: 15,
                color: Colors.black45
            ),
          ),
          ),
          ),
        ],
      ),
    );
  }
}

class AddAssicurazione extends StatefulWidget{

  static const routeName = '/add-Assicurazione';


  static List<Map<String,dynamic>> assicurazioni = [];
  static var info = null;

  static Future<Map<String,dynamic>> getAssic() async{
    if(assicurazioni.length == 0){
      var ref = FirebaseFirestore.instance.collection("assicurazione");
      var query = await ref.get();
      for (var queryDocumentSnapshot in query.docs){
        Map<String, dynamic> data = queryDocumentSnapshot.data();
        assicurazioni.add(data);
      }
    }
    return {};
  }

  @override
  State<AddAssicurazione> createState() => _AddAssicurazioneState(assicurazioni,info);
}

class _AddAssicurazioneState extends State<AddAssicurazione> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String prezzo = '';
  String tipoScad = '';
  DateTime date = DateTime.now();
  static late BuildContext contextScad;
  late List<Map<String,dynamic>> numAssic;
  List<String> assicurazioni = [];
  String selectAssic = '';
  String numero = '';
  bool blockText = true;
  var info;
  bool mod = false;
  String assicurazione = "Assicurazione";
  String stringNotifiche = "";
  String? typeAssicurazione = 'Assicurazione';
  String? allianz = 'Allianz Direct';
  String? direct = 'Direct Assicurazioni';
  String? italiana = 'Italiana Assicurazioni';
  String? quixa = 'Quixa';
  String? zurich = 'Zurich Connect';
  bool? flag;
  String? typeScadenza = 'Tipo di scadenza';
  String? uid = FirebaseAuth.instance.currentUser!.uid;
  List months =
  ['gen', 'feb', 'mar', 'apr', 'mag','giu','lug','ago','set','ott','nov','dic'];
  int? current_month;
  DateTime now = new DateTime.now();
  var formatter = new DateFormat('dd-MM-yyyy');

  List<BoxNotifica> _notifiche = [];

  _AddAssicurazioneState(List<Map<String,dynamic>> assic, info){
    numAssic = assic;
    for(int i=0;i<assic.length;i++){
      assicurazioni.add(assic[i]['nome']);
    }
    if(info != null){
      selectAssic = info['nome'];
      typeAssicurazione = info['nome'];
      for(int i=0;i<numAssic.length;i++){
        if(numAssic[i]['nome'] == selectAssic) {
          numero = numAssic[i]['numero'];
          blockText = false;
        }
      }
      prezzo = info['prezzo'];
      typeScadenza = info['tipoScad'];
      Timestamp timestamp = info['data'];
      date = DateTime.fromMillisecondsSinceEpoch(timestamp.seconds*1000);
      if(info['notifiche'] != ''){
        List<String> notifiche = info['notifiche'].split(',');
        for(int i=0;i<notifiche.length;i++){
          List<String> notifica = notifiche[i].split('-');
          _notifiche.add(BoxNotifica(notifica[1], int.parse(notifica[0]),remove: ()=>setState(()  {deleteNotifica(notifica[0],notifica[1]);})));
        }
      }
      mod = true;
    }
  }

  void deleteNotifica(String num,String time) {
    _notifiche.clear();
  }

  void _addNotif(int num,String time){
    if(_notifiche.length < 3 ) {
      bool metti = true;
      if (num == 1) {
        time == 'ore' ? time = 'ora' : time = time;
        time == 'giorni' ? time = 'giorno' : time = time;
        time == 'settimane' ? time = 'settimana' : time = time;
        time == 'mesi' ? time = 'mese' : time = time;
      }
      for (int i = 0; i < _notifiche.length; i++) {
        if (_notifiche[i].value == num && _notifiche[i].time == time) {
          metti = false;
        }
      }
      if (metti) {
        setState(() {
          _notifiche.add(BoxNotifica(time, num,
              remove: () => setState(() {
                    deleteNotifica(num.toString(), time);
                  })));
        });
      }
    }
    else{
      // non si possono aggiungere più di 3 notifiche
    }
  }

  final List<String> choiceScad = [
    "Annuale",
    "Semestrale",
    "Trimestrale"
  ];

  final List<String> itemsNotif = [
    'ore',
    'giorni',
    'settimane',
    'mesi'
  ];

  final _formKey = GlobalKey<FormState>();

  void _submit() async{
    if (_formKey.currentState!.validate()) {
      for (int i = 0; i < _notifiche.length; i++) {
        stringNotifiche +=
            _notifiche[i].value.toString() + "-" + _notifiche[i].time;
        if (i != _notifiche.length - 1) stringNotifiche += ',';
      }
      var info = {
        'titolo': 'Assicurazione',
        'nome': typeAssicurazione,
        'prezzo': prezzo,
        'dataScad': date,
        'tipoScad': typeScadenza,
        'notifiche': stringNotifiche,
        'numero': numero
      };
      if (mod) {
        Scadenze.update(info, 'Assicurazione');
      }
      else {
        Scadenze.insert(info, false);

      }
      HomePage.setPage(Scadenze(), 1);
      Navigator.of(context).pop();
      Navigator.pushReplacement(
          Scadenze.contextS,
          MaterialPageRoute(
              builder: (BuildContext context) => HomePage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    List<Widget> dialogNotif = [];
    dialogNotif = [
      SimpleDialogOption(
        key: Key('ore'),
        padding: const EdgeInsets.all(25),
        onPressed: () => {_addNotif(12, "ore"),Navigator.pop(context, true)},
        child: const Text('12 ore prima',style: TextStyle(fontSize: 18)),
      ),
      SimpleDialogOption(
        key: Key('giorno'),
        padding: const EdgeInsets.all(25),
        onPressed: () => {_addNotif(1, "giorno"),Navigator.pop(context, true)},
        child: const Text('1 giorno prima',style: TextStyle(fontSize: 18)),
      ),
      SimpleDialogOption(
        key: Key('settimana'),
        padding: const EdgeInsets.all(25),
        onPressed: () => {_addNotif(1, "settimana"),Navigator.pop(context, true)},
        child: const Text('1 settimana prima',style: TextStyle(fontSize: 18)),
      ),
      SimpleDialogOption(
        key: Key('mese'),
        padding: const EdgeInsets.all(25),
        onPressed: () => {_addNotif(1, "mese"),Navigator.pop(context, true)},
        child: const Text('1 mese prima',style: TextStyle(fontSize: 18)),
      ),
      SimpleDialogOption(
        padding: const EdgeInsets.all(25),
        onPressed: ()async{
          Navigator.pop(context, true);
          String durata = '';
          String valueDurata = '1';
          await showDialog(
            context: context,
            builder: (BuildContext context) =>
                AlertDialog(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0))),
                  title: const Text('Notifica personalizzata'),
                  content: Form(
                    child:Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 5.0),
                            child: TextFormField(
                              initialValue: 1.toString(),
                              onChanged: (value) {
                                setState(() {
                                  valueDurata = value;
                                });
                              },
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 20,
                                ),
                                hintStyle: const TextStyle(fontSize: 14),
                                filled: true,
                                fillColor: Colors.white70,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder:  OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.indigoAccent),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Inserisci un valore';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: DropdownButtonFormField2(
                              decoration: InputDecoration(
                                //Add isDense true and zero Padding.
                                //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder:  OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.indigoAccent),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white70
                              ),
                              isExpanded: true,
                              hint: const Text(
                                'Durata',
                                style: TextStyle(fontSize: 14),
                              ),
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black45,
                              ),
                              iconSize: 30,
                              buttonHeight: 60,
                              buttonPadding: const EdgeInsets.only(left: 20, right: 10),
                              dropdownDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              items: itemsNotif
                                  .map((item) =>
                                  DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ))
                                  .toList(),
                              validator: (value) {
                                if (value == null) {
                                  return 'Seleziona durata';
                                }
                              },
                              onChanged: (value) {
                                durata = value.toString();
                              },
                              onSaved: (value) {
                                durata = value.toString();
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Annulla'),
                    ),
                    TextButton(
                      onPressed: () => {Navigator.pop(context, 'OK'),_addNotif(int.parse(valueDurata), durata)},
                      child: const Text('Salva'),
                    ),
                  ],
                ),
          );
        },
        child: const Text('Personalizzata',style: TextStyle(fontSize: 18)),
      ),
    ];
    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.blue.shade300, //
        ),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  elevation: 3,
                  backgroundColor: Colors.white,
                  shape: StadiumBorder()
              ),
              onPressed:() async{
                await showDialog(
                    context: context,
                    builder: (BuildContext context){
                      List<Widget> notif = dialogNotif;
                      for(int i=0;i<_notifiche.length;i++){
                        if((_notifiche[i].value == 1 && _notifiche[i].time != "ore") || (_notifiche[i].value == 12 && _notifiche[i].time == "ore")){
                          for(int j=0;j<notif.length;j++){
                            if(notif[j].key.toString() == "[<'"+_notifiche[i].time+"'>]"){
                              notif.removeAt(j);
                            }
                          }
                        }
                      }
                      return SimpleDialog(
                        title: const Text("Aggiungi notifiche"),
                        children: notif,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25.0))),
                      );
                    }
                );
              },
              icon: Icon(
                Icons.notification_add,
                color: Colors.blue,
              ),
              label: Text("Notifiche",style: TextStyle(fontSize: 16,color: Colors.blue),),

            ),
          )
        ],
        title: Text("Assicurazione",style: TextStyle(color: Colors.blue.shade300)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        //toolbarHeight: 55,
      ),
      body: Container(
        decoration: const BoxDecoration(
            color: Color(0xFFE3F2FD),
        ),
        child:
            ListView(
    children: [
      Container(
        child:
        Image.asset(
          'images/Assicurazione.png',
          //scale:1,
          //fit: BoxFit.contain,
          height: MediaQuery.of(context).size.height * 0.24,
          width: MediaQuery.of(context).size.width,
        ),
      ),
         Container(
           margin: EdgeInsets.only(top:0, bottom: 30, left: 30, right: 30),
          decoration: BoxDecoration(
            color: Color(0xFF90CAF9),
            borderRadius: BorderRadius.all(
               Radius.circular(25),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 6.0,
              ),
            ],
          ),
          //height: MediaQuery.of(context).size.height * 0.58,
           child:
        Form(
          key: _formKey,
          child: Column(
            //shrinkWrap: true,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 15.0),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 10,
                        backgroundColor: Colors.blue,
                        shape: StadiumBorder()
                    ),
                    onPressed: () async {
                      DateTime? newDate = await showDatePicker(
                          context: context,
                          locale: const Locale("it", "IT"),
                          initialDate: date,
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100),
                          builder: (conext,child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                  colorScheme: const  ColorScheme.light(
                                    primary: Colors.lightBlue,
                                    onPrimary: Colors.white,
                                    onSurface: Colors.blueAccent,
                                  ),
                                  textButtonTheme: TextButtonThemeData(
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.lightBlue.shade50,
                                      )
                                  )
                              ),
                              child: child!,
                            );
                          }
                      );
                      if (newDate == null) return;
                      setState(() => date = newDate);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8,horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.calendar_month),
                          Text(" Data scadenza: ${formatter.format(date)}")
                        ],
                      ),
                    )
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 15.0),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        elevation: 3,
                        backgroundColor: Colors.white,
                        shadowColor: Colors.blue.withOpacity(0.09),
                        shape: StadiumBorder(),
                        side: BorderSide(color: Colors.grey, width: 1)
                    ),
                    onPressed: () async {
                      AwesomeDialog(
                        context: context,
                        headerAnimationLoop: false,
                        dialogType: DialogType.noHeader,
                        padding: EdgeInsets.zero,
                        dialogBackgroundColor: Colors.blue.shade200,
                        body:
                        Table(
                          children:  [
                            TableRow(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                    height: 120,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        elevation: 10,
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          //side: BorderSide(color: Colors.blue,width: 1.5),
                                        ),
                                      ),
                                      onPressed:  () => {
                                      for(int i=0;i<numAssic.length;i++){
                                        if(numAssic[i]['nome'] == allianz!) {
                                            setState(() {
                                              numero = numAssic[i]['numero'];
                                              blockText = false;
                                              typeAssicurazione = allianz!;
                                            })
                                          }
                                      },
                                        Navigator.pop(context),
                                      },
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Align(
                                            heightFactor: 1.5,
                                            alignment: Alignment.center,
                                            child: Image.asset('images/Allianz.png',scale: 6.5),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(vertical:0,horizontal: 6),
                                            alignment: Alignment.bottomCenter,
                                            child: Text('Allianz Direct', style: const TextStyle(
                                              fontSize: 12.0,
                                              color: Color(0xFF1A1316),

                                            ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    //child: Text(prova!, style: TextStyle(color: Colors.grey)),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                    height: 120,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          elevation: 10,
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            //side: BorderSide(color: Colors.blue,width: 1.5),
                                          )
                                      ),
                                      onPressed:  () => {
                                        for(int i=0;i<numAssic.length;i++){
                                          if(numAssic[i]['nome'] == direct!) {
                                            setState(() {
                                              numero = numAssic[i]['numero'];
                                              blockText = false;
                                              typeAssicurazione = direct!;
                                            })
                                          }
                                        },
                                        Navigator.pop(context),
                                      },
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Align(
                                            heightFactor: 1.6,
                                            alignment: Alignment.center,
                                            child: Image.asset('images/Direct.png',scale: 2.5, alignment: Alignment.center,),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(vertical:2,horizontal: 6),
                                            alignment: Alignment.bottomCenter,
                                            child: Text('Direct Assicurazioni', textAlign: TextAlign.center, style: const TextStyle(
                                              fontSize: 12.0,
                                              color: Color(0xFF1A1316),

                                            ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                ]
                            ),
                            TableRow(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                    height: 120,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          elevation: 10,
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            //side: BorderSide(color: Colors.blue,width: 1.5),
                                          )
                                      ),
                                      onPressed:  () => {
                                        for(int i=0;i<numAssic.length;i++){
                                          if(numAssic[i]['nome'] == italiana!) {
                                            setState(() {
                                              numero = numAssic[i]['numero'];
                                              blockText = false;
                                              typeAssicurazione = italiana!;
                                            })
                                          }
                                        },
                                        Navigator.pop(context),
                                      },
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Align(
                                            heightFactor: 1.3,
                                            alignment: Alignment.center,
                                            child: Image.asset('images/Italiana.png',scale: 9),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(vertical:2,horizontal: 0),
                                            alignment: Alignment.bottomCenter,
                                            child: Text('Italiana Assicurazioni', textAlign: TextAlign.center, style: const TextStyle(
                                              fontSize: 12.0,
                                              color: Color(0xFF1A1316),

                                            ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                    height: 120,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          elevation: 10,
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            //side: BorderSide(color: Colors.blue,width: 1.5),
                                          )
                                      ),
                                      onPressed:  () => {
                                        for(int i=0;i<numAssic.length;i++){
                                          if(numAssic[i]['nome'] == quixa!) {
                                            setState(() {
                                              numero = numAssic[i]['numero'];
                                              blockText = false;
                                              typeAssicurazione = quixa!;
                                            })
                                          }
                                        },
                                        Navigator.pop(context),
                                      },
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Align(
                                            heightFactor: 1.5,
                                            alignment: Alignment.center,
                                            child: Image.asset('images/Quixa.png',scale: 5.5),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(vertical:2,horizontal: 8),
                                            alignment: Alignment.bottomCenter,
                                            child: Text('Quixa', style: const TextStyle(
                                              fontSize: 12.0,
                                              color: Color(0xFF1A1316),

                                            ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ]
                            ),
                            TableRow(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                    height: 120,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          elevation: 10,
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            //side: BorderSide(color: Colors.blue,width: 1.5),
                                          )
                                      ),
                                      onPressed:  () => {
                                        for(int i=0;i<numAssic.length;i++){
                                          if(numAssic[i]['nome'] == zurich!) {
                                            setState(() {
                                              numero = numAssic[i]['numero'];
                                              blockText = false;
                                              typeAssicurazione = zurich!;
                                            })
                                          }
                                        },
                                        Navigator.pop(context),
                                      },
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Align(
                                            heightFactor: 1.8,
                                            alignment: Alignment.center,
                                            child: Image.asset('images/Zurich.png',scale: 4.5),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(vertical:2,horizontal: 0),
                                            alignment: Alignment.bottomCenter,
                                            child: Text('Zurich Connect', style: const TextStyle(
                                              fontSize: 12.0,
                                              color: Color(0xFF1A1316),

                                            ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                    height: 120,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          elevation: 10,
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            //side: BorderSide(color: Colors.blue,width: 1.5),
                                          )
                                      ),
                                        onPressed:  () => {
                                          showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.all(Radius.circular(32.0))),
                                                  title: Text('Inserisci l\'assicurazione del tuo veicolo'),
                                                  content: TextFormField(
                                                    autofocus: true,
                                                    decoration: InputDecoration(hintText: 'Inserisci qui'),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        typeAssicurazione = value;
                                                        blockText = true;
                                                      });
                                                    },
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      child: Text('Inserisci'),
                                                      onPressed: () {
                                                        var nav =  Navigator.of(context);
                                                        nav.pop();
                                                        nav.pop();
                                                      },
                                                    )
                                                  ]
                                              )
                                          ),
                                      },
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Align(
                                            heightFactor: 1.5,
                                            alignment: Alignment.center,
                                            child: Image.asset('images/OtherMaintenance.png',scale: 5),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(vertical:2,horizontal: 6),
                                            alignment: Alignment.bottomCenter,
                                            child: Text('Altro', style: const TextStyle(
                                              fontSize: 12.0,
                                              color: Color(0xFF1A1316),

                                            ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ]
                            ),
                          ],
                        ),
                      ).show();
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8,horizontal: 15),
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //Icon(Icons.calendar_month),
                          Text('$typeAssicurazione', style: TextStyle(color: Colors.black45),)
                        ],
                      ),
                    )
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 15.0),
                child: TextFormField(
                  enabled: blockText,
                  autofocus: false,
                  controller: blockText == true ? null : TextEditingController(text: numero),
                  onChanged: (value) {
                    setState(() {
                      numero = value;
                    });
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    labelText: "Numero assicurazione",
                    labelStyle: const TextStyle(fontSize: 14, color: Colors.black54),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder:  OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Colors.indigoAccent),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.indigoAccent),
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Inserisci il numero dell'assicurazione";
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 15.0),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        elevation: 3,
                        backgroundColor: Colors.white,
                        shadowColor: Colors.blue.withOpacity(0.09),
                        shape: StadiumBorder(),
                        side: BorderSide(color: Colors.grey, width: 1)
                    ),
                    onPressed: () {
                      AwesomeDialog(
                        context: context,
                        headerAnimationLoop: false,
                        dialogType: DialogType.noHeader,
                        dialogBackgroundColor: Colors.blue.shade200,
                        dialogBorderRadius: BorderRadius.all(
                            Radius.circular(30)),
                        body:
                        Container(
                            height: MediaQuery.of(context).size.height * 0.32,
                            child:
                            Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5.0, vertical: 15.0),
                                  child:
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceEvenly,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 15),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30)),
                                            color: Colors.white,
                                            boxShadow: <BoxShadow>[
                                              BoxShadow(
                                                  color: Colors.black54,
                                                  blurRadius: 20.0,
                                                  offset: Offset(0.0, 6)
                                              )
                                            ],
                                          ),
                                          child:
                                          Icon(
                                            Icons.calendar_month,
                                            size: 25.0,
                                          ),
                                        ),
                                        Container(
                                          width: 188,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10,
                                                    horizontal: 15),
                                                shape: StadiumBorder(),
                                                elevation: 10.0,
                                                backgroundColor: Colors.white
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                typeScadenza = 'Trimestrale';
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: Text('Trimestrale',
                                                style: TextStyle(fontSize: 25,
                                                    color: Colors.black87)),

                                          ),
                                        )
                                      ]
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5.0, vertical: 15.0),
                                  child:
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceEvenly,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 15),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30)),
                                            color: Colors.white,
                                            boxShadow: <BoxShadow>[
                                              BoxShadow(
                                                  color: Colors.black54,
                                                  blurRadius: 20.0,
                                                  offset: Offset(0.0, 6)
                                              )
                                            ],
                                          ),
                                          child:
                                          Icon(
                                            Icons.calendar_month,
                                            size: 25.0,
                                          ),
                                        ),
                                        Container(
                                          width: 188,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10, horizontal: 15),
                                              shape: StadiumBorder(),
                                              elevation: 10.0,
                                              backgroundColor: Colors.white,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                typeScadenza = 'Semestrale';
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: Text('Semestrale',
                                                style: TextStyle(fontSize: 25,
                                                    color: Colors.black87)),

                                          ),
                                        )
                                      ]
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5.0, vertical: 15.0),
                                  child:
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceEvenly,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 15),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30)),
                                            color: Colors.white,
                                            boxShadow: <BoxShadow>[
                                              BoxShadow(
                                                  color: Colors.black54,
                                                  blurRadius: 20.0,
                                                  offset: Offset(0.0, 6)
                                              )
                                            ],
                                          ),
                                          child:
                                          Icon(
                                            Icons.calendar_month,
                                            size: 25.0,
                                          ),
                                        ),
                                        Container(
                                          width: 188,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10,
                                                    horizontal: 15),
                                                shape: StadiumBorder(),
                                                elevation: 10.0,
                                                backgroundColor: Colors.white
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                typeScadenza = 'Annuale';
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: Text('Annuale',
                                                style: TextStyle(fontSize: 25,
                                                    color: Colors.black87)),

                                          ),
                                        )
                                      ]
                                  ),
                                ),
                              ],
                            )
                        ),
                      ).show();
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8,horizontal: 15),
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //Icon(Icons.calendar_month),
                          Text('$typeScadenza', style: TextStyle(color: Colors.black45),)
                        ],
                      ),
                    )
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 15.0),
                child: TextFormField(
                  initialValue: prezzo,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      prezzo = value;
                    });
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    labelText: "Inserisci il prezzo",
                    labelStyle: const TextStyle(fontSize: 14, color: Colors.black54),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder:  OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.indigoAccent),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Inserisci il prezzo';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                child: Column(
                    children: _notifiche
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 80.0),
                child: ElevatedButton(
                  onPressed: () => {
                  _submit()
              },
                  style: ElevatedButton.styleFrom(
                    elevation: 10,
                    backgroundColor: Colors.blue.shade200,
                    shape: const StadiumBorder(),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: const [
                        Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          "Aggiungi",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
         ),
          ],
      ),
        ),
      );
  }
}
