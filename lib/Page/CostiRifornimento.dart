import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:car_control/Page/Carburante.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_chart/d_chart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:car_control/models/costs.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CostiRifornimento extends StatefulWidget {

  static const routeName = '/costiRifornimento';

  @override
  CostiRifornimentoState createState() => CostiRifornimentoState();

}


class CostiRifornimentoState extends State<CostiRifornimento> {

  List months =
  ['gen', 'feb', 'mar', 'apr', 'mag','giu','lug','ago','set','ott','nov','dic'];

  String? selectedValue;
  DateTime? selectedDate;
  String? month;
  String? year ;
  String? fullNameMonth;
  String? newNameMonth;
  String? lastData;
  String? beforeNameMonth;
  double? newCostoRifornimento;
  double? newLitri;
  String? newDateChange;
  String? yearChange;
  double? costoAgg = 0;
  double? litriAgg = 0;
  DateTime? prova;
  var date;
  var date1;
  var date2;
  var dateTotal;
  bool flagCosto = false;
  bool flagLitri = false;
  bool flagData = false;
  bool activateFlag = false;
  bool? checkCar;
  String? a;
  DateTime now = new DateTime.now();
  var formatter = new DateFormat('dd-MM-yyyy');
  int selectedIndex = -1;
  final TextEditingController _textController = TextEditingController();
  String? datePostfix;

  readCheckCar() async {
    SharedPreferences.getInstance().then((value) { checkCar = value.getBool('checkCar');});
    //print(checkCar);

  }


  final _headerStyle = const TextStyle(
      color: Color(0xffffffff), fontSize: 15, fontWeight: FontWeight.bold);
  final _contentStyleHeader = const TextStyle(
      color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.w700);
  final _contentStyle = const TextStyle(
      color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.normal);

  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  final streamChart = FirebaseFirestore.instance.collection('CostiTotali')
      .doc('2023').collection(FirebaseAuth.instance.currentUser!.uid).orderBy('index', descending: false)
      .snapshots(includeMetadataChanges: true);

  Stream<List<Costs>> readCosts() =>
  FirebaseFirestore.instance
      .collection('CostiRifornimento')
      .where('uid', isEqualTo: uid)
      .where('mese', isEqualTo: month)
      .where('year', isEqualTo: year)
      .orderBy('index', descending: false)
      .snapshots()
      .map((snapshot) =>
  snapshot.docs.map((doc) => Costs.fromJson(doc.data())).toList()
  );

  DataRow buildTableCosts(Costs cost) {

    return DataRow(
      cells: [
        DataCell(Text('${cost.data}',
            style: _contentStyle,
            textAlign: TextAlign.right)),
        DataCell(Text('${cost.costo} €', style: _contentStyle)),
        DataCell(Text('${cost.litri}',
            style: _contentStyle,
            textAlign: TextAlign.right)),
        DataCell(IconButton(
            onPressed: () =>
    {
      a = cost.data,
      date = a?.substring(6,10),
      date1 = a?.substring(3,5),
      date2 = a?.substring(0,2),
      dateTotal = '$date-$date1-$date2',
      prova = DateTime.parse(dateTotal),
      datePostfix = a?.substring(2,10)!,
    showDialog(
    context: context,
    builder: (context){
    //headerAnimationLoop: false,
    //dialogType: DialogType.noHeader,
    //dialogBackgroundColor: Colors.blue.shade200,
    body:
    return StatefulBuilder(builder: (context,setState){
    return AlertDialog(
      backgroundColor: Colors.blue.shade200,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      content:
    Container(
    height: 400,
    child:
    Column(
    children: [
    Container(
    alignment: Alignment.center,
    child: Text('Modifica data')
    ),
    Container(
    margin: const EdgeInsets.symmetric(
    vertical: 10.0, horizontal: 6.0),
    child:
    ElevatedButton(
    style: ElevatedButton.styleFrom(
    elevation: 10,
    backgroundColor: Colors.blue,
    shape: StadiumBorder()
    ),
    onPressed: () async {
    DateTime? newDate = await showDatePicker(
    context: context,
    locale: const Locale("it", "IT"),
    initialDate: prova!,
    firstDate: DateTime(1900),
    lastDate: DateTime(2100),
    builder: (context, child) {
    return Theme(
    data: Theme.of(context).copyWith(
    colorScheme: const ColorScheme.light(
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
    setState(() {
    now = newDate;
    yearChange = now.year.toString();
    newDateChange = formatter.format(now);
    var month = now.month;
    newNameMonth = months[month - 1];
    print(newNameMonth);
    lastData = cost.data;
    var support = lastData!.substring(3,5);
    int index = int.parse(support);
    beforeNameMonth = months[index - 1];
    print(beforeNameMonth);
    flagData = true;
    });
    },
    child: Padding(
    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Icon(Icons.calendar_month),
     flagData == true ?
      Text("Data rifornimento: ${formatter.format(now)}")
         :
     Text("Data rifornimento: ${formatter.format(prova!)}")
          ],
         ),
        )
      ),
    ),
    Container(
    margin: EdgeInsets.only(top: 3),
    alignment: Alignment.center,
    child: Text('Modifica costo rifornimento')
    ),
    Container(
    margin: const EdgeInsets.symmetric(
    vertical: 6.0, horizontal: 15.0),
    child:
    TextFormField(
    initialValue: '${cost.costo}',
    autovalidateMode: AutovalidateMode
        .onUserInteraction,
    keyboardType: TextInputType.numberWithOptions(
    decimal: true),
    inputFormatters: [FilteringTextInputFormatter.allow(
    RegExp('[0-9.,]+')),
    ],
    decoration: InputDecoration(
    alignLabelWithHint: true,
    contentPadding: const EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 6,
    ),
    labelStyle: const TextStyle(
    fontSize: 14,
    color: Colors.black54,
    ),
    filled: true,
    fillColor: Colors.white,
    enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(25),
    borderSide: BorderSide(color: Colors.grey),
    ),
    focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
    color: Colors.indigoAccent),
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
    onChanged: (value) {
    setState(() {
    newCostoRifornimento = double.tryParse(value);
    if(newCostoRifornimento! > cost.costo!) {
    costoAgg = newCostoRifornimento! - cost.costo!;
    //print(costoAgg);
    }
    if(newCostoRifornimento! < cost.costo!){
    costoAgg = newCostoRifornimento! - cost.costo!;
    //print(costoAgg);
    }
    if(newCostoRifornimento == cost.costo){
    costoAgg = 0;
    }
    flagCosto = true;
    });
    },
    ),
    ),
    Container(
    margin: EdgeInsets.only(top: 3),
    alignment: Alignment.center,
    child: Text('Modifica litri')
    ),
    Container(
    margin: const EdgeInsets.symmetric(
    vertical: 6.0, horizontal: 15.0),
    child:
    TextFormField(
    initialValue: '${cost.litri}',
    autovalidateMode: AutovalidateMode
        .onUserInteraction,
    keyboardType: TextInputType.numberWithOptions(
    decimal: true),
    inputFormatters: [FilteringTextInputFormatter.allow(
    RegExp('[0-9.,]+')),
    ],
    decoration: InputDecoration(
    alignLabelWithHint: true,
    contentPadding: const EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 12
    ),
    labelStyle: const TextStyle(
    fontSize: 14,
    color: Colors.black54,
    ),
    filled: true,
    fillColor: Colors.white,
    enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(25),
    borderSide: BorderSide(color: Colors.grey),
    ),
    focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
    color: Colors.indigoAccent),
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
    onChanged: (value) {
    setState(() {
    newLitri = double.tryParse(value);
    if((newLitri! > litriAgg!) || (newLitri! < litriAgg!)) {
    litriAgg = newLitri! - cost.litri!;
    }
    if(newLitri == litriAgg){
    litriAgg = 0;
    }
    flagLitri = true;
    });
    },
    ),
    ),
    Container(
    margin: const EdgeInsets.symmetric(
    vertical: 3.0, horizontal: 60.0),
    child: ElevatedButton(
    onPressed:
    () async
    {
    AwesomeDialog(
    context: context,
    dialogType: DialogType.warning,
    headerAnimationLoop: false,
    animType: AnimType.topSlide,
    title: 'Attenzione!',
    desc:
    'Sicuro di voler procedere con l\' eliminazione?',
    btnCancelText: 'No',
    btnOkText: 'Si',
    btnCancelOnPress: () {},
    btnOkOnPress: () async {

    //int indexMonth = now.month;
    //String month = months[indexMonth - 1];

      final docMonth = await FirebaseFirestore.instance.collection('CostiRifornimento').where('uid', isEqualTo: uid).where('index', isEqualTo: cost.index).get();
      var docsMonth = docMonth.docs;
      String month = docsMonth[0]['mese'];
      String year = docsMonth[0]['year'];

    final doc = await FirebaseFirestore.instance
        .collection('CostiRifornimento')
        .where(
    'mese', isEqualTo: month)
        .where('year', isEqualTo: year)
        .where('uid', isEqualTo: uid)
        .get();
    var docs = doc.docs;
    double sum = 0.0;
    double sumLitri = 0.0;
    for (int i = 0; i < docs.length; i++) {
    sum += docs[i]['costo'];
    print('costo $sum');
    }
    for (int i = 0; i < docs.length; i++) {
    sumLitri += docs[i]['litri'];
    print('litri $sumLitri');
    }

    final docGeneral = await FirebaseFirestore.instance
        .collection('CostiGenerali').doc(year)
        .collection(uid).where(
    'mese', isEqualTo: month)
        .get();
    var docs1 = docGeneral.docs;
    double sum1 = 0.0;
    sum1 += docs1[0]['costo'];


    await FirebaseFirestore.instance.collection(
    'CostiTotali').doc(year)
        .collection(uid)
        .doc(month)
        .update({"costoRifornimento": sum - (cost.costo!), "totaleLitri": sumLitri - cost.litri!});


    await FirebaseFirestore.instance.collection(
    'CostiGenerali').doc(year)
        .collection(uid)
        .doc(month)
        .update({"costo": sum1 - (cost.costo!)});

    final docDeleted = await FirebaseFirestore.instance.collection('CostiRifornimento').where('uid', isEqualTo: uid).where('index', isEqualTo: cost.index).get();
    DocumentReference docu = docDeleted.docs[0].reference;
    docu.delete();

    Navigator.of(context, rootNavigator: true).pop();
    },
    ).show();
    },
    style: ElevatedButton.styleFrom(
    elevation: 10,
    backgroundColor: Colors.red.shade300,
    shape: const StadiumBorder(),

    ),
                  child: Padding(
                  padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 0,
                  ),
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                    Icon(
                    Icons.remove,
                    color: Colors.white,
                    ),
                    SizedBox(
                    width: 14,
                    ),
                    Text(
                    "Rimuovi",
                    style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                         ),
                )
            ],
          ),
         ),
       ),
      ),
    Container(
      padding: EdgeInsets.only(top: 6),
      child:
      Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.only(top: 2),
          child:
              FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  icon: Icon( // <-- Icon
                    Icons.cancel_outlined,
                    size: 18.0,
                  ),
                label: Text('Annulla'),
                backgroundColor: Colors.red,
                ),
              ),
        Container(
          width: 120,
          child:
          FloatingActionButton.extended(
            onPressed: () async{

              //int indexMonth = now.month;
              //String month = months[indexMonth - 1];
              //print('Mese qui $month');

              if(flagCosto == false) {
                newCostoRifornimento = cost.costo;
                costoAgg = 0;
              }

              if(flagLitri == false) {
                newLitri = cost.litri;
                litriAgg = 0;
              }

              if(flagData == false) {
                print(cost.data);
                newDateChange = cost.data;
                newNameMonth = cost.mese;
                yearChange = cost.year;
              }

                /*final doc = await FirebaseFirestore.instance
                    .collection('CostiRifornimento')
                    .where(
                    'mese', isEqualTo: newNameMonth)
                    .where('uid', isEqualTo: uid)
                    .get();
                var docs = doc.docs;
                for (int i = 0; i < docs.length; i++) {
                  sum += docs[i]['costo'];
                }
                for (int i = 0; i < docs.length; i++) {
                  sumLitri += docs[i]['litri'];
                }
              print('costo $sum');
              print('litri $sumLitri');

                final docGeneral = await FirebaseFirestore.instance
                    .collection('CostiGenerali').doc('2022')
                    .collection(uid).where(
                    'mese', isEqualTo: newNameMonth)
                    .get();
                var docs1 = docGeneral.docs;
                sum1 += docs1[0]['costo'];


              final doc1 = await FirebaseFirestore.instance.collection('CostiRifornimento').where('uid', isEqualTo: uid).where('index', isEqualTo: cost.index).get();
              DocumentReference docu = doc1.docs[0].reference;
              docu.update({'costo': newCostoRifornimento, 'recapRifornimento': newCostoRifornimento, 'litri': newLitri, 'recapLitri': newLitri, "data": newDateChange, "mese": newNameMonth});
*/
              if(flagData == true) {
                //Caso in cui cambio data ma scelgo un mese diverso
                if(newNameMonth! != beforeNameMonth!){
                  double beforeSum = 0.0;
                  double beforeSumLitri = 0.0;
                  double newSum = 0.0;
                  double newSumLitri = 0.0;
                  double sum1Before = 0.0;
                  double sum1New = 0.0;
                  final doc = await FirebaseFirestore.instance
                      .collection('CostiRifornimento')
                      .where(
                      'mese', isEqualTo: beforeNameMonth)
                      .where('year', isEqualTo: yearChange)
                      .where('uid', isEqualTo: uid)
                      .get();
                  var docs = doc.docs;
                  for (int i = 0; i < docs.length; i++) {
                    beforeSum += docs[i]['costo'];
                  }
                  for (int i = 0; i < docs.length; i++) {
                    beforeSumLitri += docs[i]['litri'];
                  }
                  print('costo old $beforeSum');
                  print('litri old $beforeSumLitri');

                  print('before month $beforeNameMonth');
                  print(yearChange);
                  final docGeneralBefore = await FirebaseFirestore.instance
                      .collection('CostiGenerali').doc(yearChange)
                      .collection(uid).where(
                      'mese', isEqualTo: beforeNameMonth)
                      .get();
                  var docs1Before = docGeneralBefore.docs;
                  sum1Before += docs1Before[0]['costo'];
                  print('sum1Before $sum1Before');

                  final doc1 = await FirebaseFirestore.instance.collection('CostiRifornimento').where('uid', isEqualTo: uid).where('index', isEqualTo: cost.index).get();
                  DocumentReference docu = doc1.docs[0].reference;
                  docu.update({'costo': newCostoRifornimento, 'recapRifornimento': newCostoRifornimento, 'litri': newLitri, 'recapLitri': newLitri, "data": newDateChange, "mese": newNameMonth});

                  final docNew = await FirebaseFirestore.instance
                      .collection('CostiRifornimento')
                      .where(
                      'mese', isEqualTo: newNameMonth)
                      .where('year', isEqualTo: yearChange)
                      .where('uid', isEqualTo: uid)
                      .get();
                  var docsNew = docNew.docs;
                  print('lunghezza ${docsNew.length}');
                  for (int i = 0; i < docsNew.length; i++) {
                    newSum += docsNew[i]['costo'];
                  }
                  for (int i = 0; i < docsNew.length; i++) {
                    newSumLitri += docsNew[i]['litri'];
                  }
                  print('costo new quiqui $newSum');
                  print('litri new qui qui $newSumLitri');

                  final docGeneralAfter = await FirebaseFirestore.instance
                      .collection('CostiGenerali').doc(yearChange)
                      .collection(uid).where(
                      'mese', isEqualTo: newNameMonth)
                      .get();
                  var docs1After = docGeneralAfter.docs;
                  sum1New += docs1After[0]['costo'];
                  print('sum1New $sum1New');

                await FirebaseFirestore.instance.collection(
                    'CostiTotali').doc(yearChange)
                    .collection(uid)
                    .doc(beforeNameMonth)
                    .update({"costoRifornimento": beforeSum - (newCostoRifornimento! - costoAgg!), "totaleLitri": beforeSumLitri - (newLitri! - litriAgg!)});

                  await FirebaseFirestore.instance.collection(
                      'CostiTotali').doc(yearChange)
                      .collection(uid)
                      .doc(newNameMonth)
                      .update({
                    "costoRifornimento": newSum,
                    "totaleLitri": newSumLitri
                  });

                  await FirebaseFirestore.instance.collection(
                      'CostiGenerali').doc(yearChange)
                      .collection(uid)
                      .doc(beforeNameMonth)
                      .update({"costo": sum1Before - (newCostoRifornimento! - costoAgg!)});

                  await FirebaseFirestore.instance.collection(
                      'CostiGenerali').doc(yearChange)
                      .collection(uid)
                      .doc(newNameMonth)
                      .update({"costo": sum1New + newCostoRifornimento!});

                }
                else {
                  //Caso in cui cambio data ma scelgo sempre lo stesso mese
                  double sum = 0.0;
                  double sumLitri = 0.0;
                  double sum1 = 0.0;

                  print('Cambio data ma stesso mese $newNameMonth');

                  final doc1 = await FirebaseFirestore.instance.collection('CostiRifornimento').where('uid', isEqualTo: uid).where('index', isEqualTo: cost.index).get();
                  DocumentReference docu = doc1.docs[0].reference;
                  docu.update({'costo': newCostoRifornimento, 'recapRifornimento': newCostoRifornimento, 'litri': newLitri, 'recapLitri': newLitri, "data": newDateChange, "mese": newNameMonth});

                  final doc = await FirebaseFirestore.instance
                      .collection('CostiRifornimento')
                      .where(
                      'mese', isEqualTo: newNameMonth)
                      .where('year', isEqualTo: yearChange)
                      .where('uid', isEqualTo: uid)
                      .get();
                  var docs = doc.docs;
                  for (int i = 0; i < docs.length; i++) {
                    sum += docs[i]['costo'];
                  }
                  for (int i = 0; i < docs.length; i++) {
                    sumLitri += docs[i]['litri'];
                  }

                  final docGeneral = await FirebaseFirestore.instance
                      .collection('CostiGenerali').doc(yearChange)
                      .collection(uid).where(
                      'mese', isEqualTo: newNameMonth)
                      .get();
                  var docs1 = docGeneral.docs;
                  sum1 += docs1[0]['costo'];
                  print('Cambio data ma stesso mese costi gen $sum1');

                  await FirebaseFirestore.instance.collection(
                      'CostiTotali').doc(yearChange)
                      .collection(uid)
                      .doc(newNameMonth)
                      .update({
                    "costoRifornimento": sum ,
                    "totaleLitri": sumLitri
                  });

                  await FirebaseFirestore.instance.collection(
                      'CostiGenerali').doc(yearChange)
                      .collection(uid)
                      .doc(newNameMonth)
                      .update({"costo": sum1 + costoAgg! });
                }
              }
              //Caso in cui non cambio data
              else {

                double sum = 0.0;
                double sumLitri = 0.0;
                double sum1 = 0.0;

                final doc = await FirebaseFirestore.instance
                    .collection('CostiRifornimento')
                    .where(
                    'mese', isEqualTo: newNameMonth)
                    .where('year', isEqualTo: yearChange)
                    .where('uid', isEqualTo: uid)
                    .get();
                var docs = doc.docs;
                for (int i = 0; i < docs.length; i++) {
                  sum += docs[i]['costo'];
                }
                for (int i = 0; i < docs.length; i++) {
                  sumLitri += docs[i]['litri'];
                }

                final docGeneral = await FirebaseFirestore.instance
                    .collection('CostiGenerali').doc(yearChange)
                    .collection(uid).where(
                    'mese', isEqualTo: newNameMonth)
                    .get();
                var docs1 = docGeneral.docs;
                sum1 += docs1[0]['costo'];

                final doc1 = await FirebaseFirestore.instance.collection('CostiRifornimento').where('uid', isEqualTo: uid).where('index', isEqualTo: cost.index).get();
                DocumentReference docu = doc1.docs[0].reference;
                docu.update({'costo': newCostoRifornimento, 'recapRifornimento': newCostoRifornimento, 'litri': newLitri, 'recapLitri': newLitri, "data": newDateChange, "mese": newNameMonth});

                await FirebaseFirestore.instance.collection(
                    'CostiTotali').doc(yearChange)
                    .collection(uid)
                    .doc(newNameMonth)
                    .update({
                  "costoRifornimento": sum + (costoAgg!),
                  "totaleLitri": sumLitri + (litriAgg!)
                });

                await FirebaseFirestore.instance.collection(
                    'CostiGenerali').doc(yearChange)
                    .collection(uid)
                    .doc(newNameMonth)
                    .update({"costo": sum1 + (costoAgg!)});
              }

              Navigator.of(context, rootNavigator: true).pop();

            },
            icon: Icon( // <-- Icon
              Icons.check_circle,
              size: 18.0,
            ),
            label: Text('Ok'),
            backgroundColor: Colors.green.shade400,
                             ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      ),
    },
            icon: Icon(Icons.edit, color: Colors.grey,)
          ),
        ),
      ],
    );
  }


  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.center,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF90CAF9), Colors.white],
            )
        ),

        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 200, horizontal: 10),
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              decoration: BoxDecoration(
                //border: Border.all(color: Colors.blueAccent),
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30.0),
                  bottomLeft: Radius.circular(30.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueGrey,
                    blurRadius: 2.0,
                    spreadRadius: 0.0,
                    offset: Offset(2.0, 2.0), // shadow direction: bottom right
                  )
                ],
              ),
              child: StreamBuilder(
                  stream: streamChart,
                  builder: (context, AsyncSnapshot<
                      QuerySnapshot<Map<String, dynamic>>> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }
                    if (snapshot.data == null) {
                      //return const Text("Empty");
                      return Center(child: CircularProgressIndicator());
                    }
                    List<Map<String, dynamic>> listChart = snapshot.data!.docs
                        .map((e) {
                      return {
                        'domain': e.data()['mese'],
                        'measure': e.data()['costoRifornimento'],
                      };
                    }).toList();
                    return AspectRatio(
                      aspectRatio: 16 / 9,
                      child: DChartBar(
                        data: [
                          {
                            'id': 'Bar',
                            'data': listChart,
                          },
                        ],
                        axisLineColor: Colors.lightBlue,
                        barColor: (barData, index, id) => Colors.lightBlue,
                        showBarValue: true,
                      ),
                    );
                  }
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 25.0,horizontal: 0.0),
              alignment: Alignment.center,
              child:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton.icon(
                    icon: Icon(Icons.filter_alt_outlined, color: Colors.white,),
                    label: (month == null && year == null)? Text('Filtra per mese ed anno', style: TextStyle(color: Colors.white),) : Text('$fullNameMonth \t $year', style: TextStyle(color: Colors.white),),
                    style: TextButton.styleFrom(
                      elevation: 10.0,
                      backgroundColor: Colors.lightBlue.shade200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    onPressed: () {
                      DatePicker.showPicker(context, showTitleActions: true,
                          onChanged: (date) {
                          }, onConfirm: (date) {
                            int selectedMonth = date.month;
                            month = months[selectedMonth - 1];
                            setState(() {
                              month = months[selectedMonth - 1];
                              year = date.year.toString();
                              fullNameMonth = generateFullNameMonth(month);
                            });
                          },
                          onCancel: (){
                            setState(() {
                              month = null;
                              year = null;
                            });
                          },
                          pickerModel: CustomMonthPicker(
                              currentTime: DateTime.now(),
                              minTime: DateTime(2022,1),
                              maxTime: DateTime(2023,12),
                              locale: LocaleType.it),
                          locale: LocaleType.it);
                    },
                  ),
                  TextButton.icon(
                    icon: Icon(Icons.add, color: Colors.white,),
                    label: Text('Rifornimento', style: TextStyle(color: Colors.white)),
                    style: TextButton.styleFrom(
                      elevation: 10.0,
                      backgroundColor: Colors.lightBlue.shade200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    onPressed: () async {
                      await readCheckCar();
                      if(checkCar == true) {
                        Navigator.of(context).pushNamed(Carburante.routeName);
                      }
                      else {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.warning,
                          headerAnimationLoop: false,
                          animType: AnimType.topSlide,
                          title: 'Attenzione!',
                          desc:
                          'Aggiungi prima un veicolo!',
                          btnCancelText: 'Cancella',
                          btnCancelOnPress: () {},
                          btnOkOnPress: () {
                          },
                        ).show();
                      }
                    },
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 6, horizontal:35),
              decoration: BoxDecoration(
                  //border: Border.all(width: 1, color: Colors.red),
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueGrey,
                    blurRadius: 6.0,
                    //spreadRadius: 0.0,
                    //offset: Offset(-2.0, 2.0,), // shadow direction: bottom right
                  )
                ],
              ),
                child:
                    Column(
                    children:[
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                            //border: Border.all(width: 1, color: Colors.red),
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            color: Colors.lightBlue.shade200,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueGrey,
                              blurRadius: 3.0,
                              //spreadRadius: 0.0,
                              //offset: Offset(-2.0, 2.0,), // shadow direction: bottom right
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:[
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                              child:
                            Icon(
                              Icons.local_gas_station,
                              size: 25,
                              color: Colors.white,
                            ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                              child:
                            Text('Storico Rifornimenti', style: TextStyle(
                              fontSize: 25, color: Colors.white, fontWeight: FontWeight.w500
                            ),
                            ),
                            ),
                          ]
                        ),
                    ),
                      StreamBuilder<List<Costs>>(
                        stream: readCosts(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final cost = snapshot.data!;
                            return
                              SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                                child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                              child : DataTable(
                              columnSpacing: 24,
                              sortAscending: true,
                              sortColumnIndex: 1,
                              dataRowHeight: 40,
                              showBottomBorder: false,
                              columns: [
                                DataColumn(
                                    label: Text(
                                        'Data', style: _contentStyleHeader),
                                    numeric: true),
                                DataColumn(
                                    label: Text(
                                        'Costo', style: _contentStyleHeader)),
                                DataColumn(
                                    label: Text(
                                        'Litri', style: _contentStyleHeader),
                                    numeric: true),
                                DataColumn(
                                    label: Text(
                                        ''),
                                    numeric: true),
                              ],
                              //shrinkWrap: true,
                              rows:
                              cost.map(buildTableCosts).toList(),

                            ),
                          ),
                          );
                          }
                          else {
                            return Center(child: CircularProgressIndicator());
                          }
                        },
                      )
                    ],
                  ),
                  ),
                ],
              ),
            ),
        );
  }


  String? generateFullNameMonth(String? month) {

    if(month == 'gen'){
      return 'Gennaio';
    }
    if(month == 'feb'){
      return 'Febbraio';
    }
    if(month == 'mar'){
      return 'Marzo';
    }
    if(month == 'apr'){
      return 'Aprile';
    }
    if(month == 'mag'){
      return 'Maggio';
    }
    if(month == 'giu'){
      return 'Giugno';
    }
    if(month == 'lug'){
      return 'Luglio';
    }
    if(month == 'ago'){
      return 'Agosto';
    }
    if(month == 'set'){
      return 'Settembre';
    }
    if(month == 'ott'){
      return 'Ottobre';
    }
    if(month == 'nov'){
      return 'Novembre';
    }
    if(month == 'dic'){
      return 'Dicembre';
    }
    return null;

  }
}

class CustomMonthPicker extends DatePickerModel {
  CustomMonthPicker({required DateTime currentTime, required DateTime minTime, required DateTime maxTime,
    required LocaleType locale}) : super(locale: locale, minTime: minTime, maxTime:
  maxTime, currentTime: currentTime);

  @override
  List<int> layoutProportions() {
    return [1, 1, 0];
  }
}
