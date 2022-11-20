import 'package:car_control/Page/Scadenze.dart';
import 'package:car_control/Page/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BoxNofitica extends StatefulWidget{
  late int value;
  late String time;
  void Function()? remove;

  BoxNofitica(String testo, int num, {super.key,required this.remove}){
    time = testo;
    value = num;
  }
  @override
  State<BoxNofitica> createState() => _BoxNotificaState(time,value,remove);
}

class _BoxNotificaState extends State<BoxNofitica>{
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
              onPressed: remove,
              icon: Icon(Icons.close)),
          Text(
            _testoNotifica,
            style: const TextStyle(
                fontSize: 18
            ),
          )
        ],
      ),
    );
  }
}

class AddAssicurazione extends StatefulWidget{
  static const routeName = '/add-Assicurazione';

  static List<Map<String,dynamic>> assicurazioni = [];

  static Future<Map<String,dynamic>> getAssic() async{
    if(assicurazioni.length == 0){
      var ref = FirebaseFirestore.instance.collection("assicurazione");
      var query = await ref.get();
      for (var queryDocumentSnapshot in query.docs){
        Map<String, dynamic> data = queryDocumentSnapshot.data();
        print(data);
        assicurazioni.add(data);
      }
    }
    return {};
  }

  @override
  State<AddAssicurazione> createState() => _AddAssicurazioneState(assicurazioni);
}

class _AddAssicurazioneState extends State<AddAssicurazione> {
  String prezzo ="";
  String tipoScad ="";
  DateTime date = DateTime.now();

  late List<Map<String,dynamic>> numAssic;
  List<String> assicurazioni = [];
  String selectAssic = '';
  String numero = '';
  bool blockText = true;

  List<BoxNofitica> _notifiche = [];

  _AddAssicurazioneState(List<Map<String,dynamic>> assic){
    numAssic = assic;
    for(int i=0;i<assic.length;i++){
      assicurazioni.add(assic[i]['nome']);
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
        _notifiche.add(BoxNofitica(time, num, remove: ()=>setState(() {_notifiche.clear();}))
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

  void _submit(){
    if (_formKey.currentState!.validate()){
      var info = {
        'titolo': 'Assicurazione',
        'nome': selectAssic,
        'prezzo': prezzo,
        'tipoScad': tipoScad,
        'dataScad': date,
        'tipoScad': tipoScad,
        'notifiche': _notifiche,
      };
      Scadenze.insert(info);
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
        actions: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 10,
                  backgroundColor: Colors.white70,
                  shape: StadiumBorder()
              ),
              onPressed: _submit,
              child: Text("Salva",style: TextStyle(fontSize: 18,color: Colors.blue),),

            ),
          )
        ],
        title: Text("Assicurazione"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        toolbarHeight: 55,
        flexibleSpace: Container(
          decoration:const BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
              gradient: LinearGradient(
                  colors: [Colors.cyan,Colors.lightBlue],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft
              )
          ),
        ),
      ),
      body: Container(
        //padding: EdgeInsets.only(top: 20.0,left: 20.0, right: 20.0),
        decoration:const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.lightBlue, Colors.white70],
            )
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 15.0),
                alignment: Alignment.center,
                child: Image.asset('images/insurance.png',height: 120,width: 120),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 15.0),
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
                    'Assicurazione',
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
                  items: assicurazioni
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
                      return 'Seleziona assicurazione';
                    }
                  },
                  onChanged: (value) {

                    selectAssic = value.toString();
                    for(int i=0;i<numAssic.length;i++){
                      if(numAssic[i]['nome'] == selectAssic) {
                        setState(() {
                          numero = numAssic[i]['numero'];
                          blockText = false;
                        });
                      }
                    }
                  },
                  onSaved: (value) {
                    selectAssic = value.toString();
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 15.0),
                child: TextFormField(
                  enabled: blockText,
                  controller: TextEditingController(text: numero),
                  onChanged: (value) {
                    setState(() {
                      numero = value;
                    });
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    hintText: "Numero assicurazione",
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
                      return "Inserisci il numero dell'assicurazione";
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 15.0),
                child: TextFormField(
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
                      return 'Inserisci il prezzo';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 15.0),
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
                    'Tipologia scadenza',
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
                  items: choiceScad
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
                      return 'Seleziona tipologia scadenza';
                    }
                  },
                  onChanged: (value) {
                    tipoScad = value.toString();
                  },
                  onSaved: (value) {
                    tipoScad = value.toString();
                  },
                ),
              ),
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
                margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 15.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 10,
                      backgroundColor: Colors.blue,
                      shape: const StadiumBorder()
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
                          );
                        }
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.notification_add),
                        Text(" Aggiungi notifiche")
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                child: Column(
                    children: _notifiche
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
