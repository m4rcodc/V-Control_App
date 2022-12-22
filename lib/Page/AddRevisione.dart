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

class AddRevisione extends StatefulWidget{
  static const routeName = '/add-revisione';

  static var info = null;

  @override
  State<AddRevisione> createState() => _AddRevisioneState(info);

}

class _AddRevisioneState extends State<AddRevisione> {
  String prezzo ="";
  String tipoScad ="";
  DateTime date = DateTime.now();
  bool mod = false;
  String stringNotifiche = '';
  String revisione = "Revisione";
  String? uid = FirebaseAuth.instance.currentUser!.uid;
  List months =
  ['gen', 'feb', 'mar', 'apr', 'mag','giu','lug','ago','set','ott','nov','dic'];
  int? current_month;
  DateTime now = new DateTime.now();
  var formatter = new DateFormat('dd-MM-yyyy');

  List<BoxNotifica> _notifiche = [];

  _AddRevisioneState(info){
    if(info != null){
      prezzo = info['prezzo'];
      Timestamp timestamp = info['data'];
      date = DateTime.fromMillisecondsSinceEpoch(timestamp.seconds*1000);
      if(info['notifiche'] != ''){
        List<String> notifiche = info['notifiche'].split(',');
        for(int i=0;i<notifiche.length;i++){
          List<String> notifica = notifiche[i].split('-');
          _notifiche.add(BoxNotifica(notifica[1], int.parse(notifica[0]),remove: ()=>setState(() {_notifiche.clear();})));
        }
      }
      mod = true;
    }
  }

  void _addNotif(int num,String time){
    bool metti = true;
    if(num == 1){
      time == 'ore' ? time = 'ora' : time = time;
      time == 'giorni' ? time = 'giorno' : time = time;
      time == 'settimane' ? time = 'settimana' : time = time;
      time == 'mesi' ? time = 'mese' : time = time;
    }
    for(int i=0;i<_notifiche.length;i++){
      if(_notifiche[i].value == num && _notifiche[i].time == time){
        metti = false;
      }
    }
    if(metti){
      setState(() {
        _notifiche.add(BoxNotifica(time, num, remove: ()=>setState(() {_notifiche.clear();}))
        );
      });
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
    if (_formKey.currentState!.validate()){
      for(int i=0;i<_notifiche.length;i++){
        stringNotifiche += _notifiche[i].value.toString()+"-"+_notifiche[i].time;
        if(i != _notifiche.length-1) stringNotifiche += ',';
      }

      var info = {
        'titolo': 'Revisione',
        'nome': '',
        'prezzo': prezzo,
        'dataScad': date,
        'notifiche': stringNotifiche,
        'tipoScad': ''
      };
      if(mod){
        Scadenze.update(info,'Revisione');
        AddRevisione.info = null;
      }
      else{
        Scadenze.insert(info,false);
      }
      HomePage.setPage(Scadenze(), 1);
      Navigator.of(context).popAndPushNamed(HomePage.routeName);
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
                                  print(valueDurata);
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.blue.shade300,
        ),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
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
              label: Text("Notifiche",style: TextStyle(fontSize: 18,color: Colors.blue),),

            ),
          )
        ],
        title: Text("Revisione",style: TextStyle(color: Colors.blue.shade300)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        //toolbarHeight: 55,
      ),
      body: Container(
        //padding: EdgeInsets.only(top: 20.0,left: 20.0, right: 20.0),
        decoration:const BoxDecoration(
            color: Color(0xFFE3F2FD)
        ),
        child:
        ListView(
          children: [
        Container(
        margin: EdgeInsets.only(top: 25),
        child:
        Image.asset(
          'images/Revisione.png',
          //scale:1,
          //fit: BoxFit.contain,
          height: MediaQuery.of(context).size.height * 0.30,
          width: MediaQuery.of(context).size.width,
        ),
      ),
        Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03, bottom: 30, left: 30, right: 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            color: Color(0xFF90CAF9),
            boxShadow: [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 6.0,
              ),
            ],
          ),
          child:
          Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 25.0,horizontal: 15.0),
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
                      padding: EdgeInsets.symmetric(vertical: 15,horizontal: 15),
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
                margin: const EdgeInsets.symmetric(vertical: 25.0,horizontal: 15.0),
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
                      horizontal: 20,
                      vertical: 20,
                    ),
                    hintText: "Inserisci il prezzo",
                    hintStyle: const TextStyle(fontSize: 14),
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
