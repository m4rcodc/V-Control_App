import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:car_control/Page/Manutenzione.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_chart/d_chart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:car_control/models/costs.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CostiManutenzione extends StatefulWidget{

  @override
  CostiManutenzioneState createState() => CostiManutenzioneState();
}

class CostiManutenzioneState extends State<CostiManutenzione>{

  List months =
  ['gen', 'feb', 'mar', 'apr', 'mag','giu','lug','ago','set','ott','nov','dic'];

  String? selectedValue;
  DateTime? selectedDate;
  String? month;
  String? year;
  String? fullNameMonth;
  double? newCostoManutenzione;
  String? newNote;
  String? newDate;
  double? costoAgg = 0;
  bool flagCosto = false;
  bool? flagNote = false;
  bool? flagDate = false;
  bool? checkCar;
  DateTime now = new DateTime.now();
  var formatter = new DateFormat('dd-MM-yyyy');
  String? a;
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

  @override
  final streamChart = FirebaseFirestore.instance.collection('CostiTotaliManutenzione')
      .doc('2022').collection(FirebaseAuth.instance.currentUser!.uid).orderBy('index', descending: false)
      .snapshots(includeMetadataChanges: true);

  String uid = FirebaseAuth.instance.currentUser!.uid;

  Stream<List<Costs>> readCosts() =>
      FirebaseFirestore.instance
          .collection('CostiManutenzione')
          .where('uid', isEqualTo: uid)
          .where('mese', isEqualTo: month)
          .where('year', isEqualTo: year)
          .orderBy('index', descending: false)
          .snapshots()
          .map((snapshot) =>
          snapshot.docs.map((doc) => Costs.fromJson(doc.data())).toList()
      );

  DataRow buildTableCosts(Costs cost) =>
      DataRow(
        cells: [
          DataCell(Text('${cost.data}',
              style: _contentStyle,
              textAlign: TextAlign.right)),
          DataCell(Text('${cost.costo}€', style: _contentStyle)),
          DataCell(IconButton(
            onPressed: () => {
                  AwesomeDialog(
                  context: context,
                  headerAnimationLoop: false,
                  dialogType: DialogType.noHeader,
                  title: '${cost.type}',
                  desc:'${cost.note}',
                  btnOkOnPress: () {
                        },
                  btnCancelIcon: Icons.cancel_outlined,
                  btnOkIcon: Icons.check_circle,
                         ).show()
                      },
              padding: EdgeInsets.only(left: 15),
              icon: Icon(Icons.visibility_outlined, color: Colors.grey,))
                  ),
          DataCell(IconButton(
              onPressed: () =>
              {
                a = cost.data,
                datePostfix = a?.substring(2,10)!,
                print(datePostfix),
                AwesomeDialog(
                  context: context,
                  headerAnimationLoop: false,
                  dialogType: DialogType.noHeader,
                  dialogBackgroundColor: Colors.blue.shade200,
                  body:
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
                                vertical: 15.0, horizontal: 15.0),
                            child:
                            TextFormField(
                              autovalidateMode: AutovalidateMode
                                  .onUserInteraction,
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              inputFormatters: [FilteringTextInputFormatter.allow(
                                  RegExp('[0-9.,-]+')),
                              ],
                              decoration: InputDecoration(
                                alignLabelWithHint: true,
                                hintText: cost.data,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
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
                              controller: _textController,
                              onChanged: (value) {
                                setState(() {
                                  if (value == datePostfix) {
                                    _textController.text = "";
                                    return;
                                  }
                                  value.endsWith(datePostfix!)
                                      ? _textController.text = value
                                      : _textController.text = value + datePostfix!;
                                  _textController.selection = TextSelection.fromPosition(
                                      TextPosition(
                                          offset: _textController.text.length! -
                                              datePostfix!.length));
                                  /* print('sono qui');
                                newDate = value;
                                print(newDate);
                                flagDate == true;
                                */
                                });
                              },
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(top: 20),
                              alignment: Alignment.center,
                              child: Text('Modifica costo manutenzione')
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 15.0),
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
                                  vertical: 16,
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
                                  newCostoManutenzione = double.tryParse(value);
                                  if(newCostoManutenzione! > cost.costo!) {
                                    costoAgg = newCostoManutenzione! - cost.costo!;
                                    //print(costoAgg);
                                  }
                                  if(newCostoManutenzione! < cost.costo!){
                                    costoAgg = newCostoManutenzione! - cost.costo!;
                                    //print(costoAgg);
                                  }
                                  if(newCostoManutenzione == cost.costo){
                                    costoAgg = 0;
                                  }
                                  flagCosto = true;
                                });
                              },
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(top: 20),
                              alignment: Alignment.center,
                              child: Text('Modifica note')
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 15.0),
                            child:
                            TextFormField(
                              initialValue: cost.note,
                              autovalidateMode: AutovalidateMode
                                  .onUserInteraction,
                              decoration: InputDecoration(
                                alignLabelWithHint: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
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
                                  newNote = value;
                                  flagNote = true;
                                });
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 6.0, horizontal: 80.0),
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

                                    int indexMonth = now.month;
                                    String month = months[indexMonth - 1];

                                    final doc = await FirebaseFirestore.instance
                                        .collection('CostiManutenzione')
                                        .where(
                                        'mese', isEqualTo: month)
                                        .where('uid', isEqualTo: uid)
                                        .get();
                                    var docs = doc.docs;
                                    double sum = 0.0;
                                    for (int i = 0; i < docs.length; i++) {
                                      sum += docs[i]['costo'];
                                      print('costo $sum');
                                    }
                                    final docGeneral = await FirebaseFirestore.instance
                                        .collection('CostiGenerali').doc('2022')
                                        .collection(uid).where(
                                        'mese', isEqualTo: month)
                                        .get();
                                    var docs1 = docGeneral.docs;
                                    double sum1 = 0.0;
                                    sum1 += docs1[0]['costo'];

                                    await FirebaseFirestore.instance.collection(
                                        'CostiTotaliManutenzione').doc('2022')
                                        .collection(uid)
                                        .doc(month)
                                        .update({"costoManutenzione": sum - (cost.costo!)});

                                    await FirebaseFirestore.instance.collection(
                                        'CostiGenerali').doc('2022')
                                        .collection(uid)
                                        .doc(month)
                                        .update({"costo": sum1 - (cost.costo!)});

                                    final docDeleted = await FirebaseFirestore.instance.collection('CostiManutenzione').where('uid', isEqualTo: uid).where('index', isEqualTo: cost.index).get();
                                    DocumentReference docu =  docDeleted.docs[0].reference;
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
                        ],
                      )

                  ),
                  btnOkOnPress: () async{

                    int indexMonth = now.month;
                    String month = months[indexMonth - 1];

                    if(flagCosto == false) {
                      newCostoManutenzione = cost.costo;
                      costoAgg = 0;

                    }
                    if(flagNote == false) {
                      newNote = cost.note;
                    }

                    if(flagDate == false) {
                      newDate = cost.data;
                      print(newDate);
                    }

                    final doc = await FirebaseFirestore.instance
                        .collection('CostiManutenzione')
                        .where(
                        'mese', isEqualTo: month)
                        .where('uid', isEqualTo: uid)
                        .get();
                    var docs = doc.docs;
                    double sum = 0.0;
                    for (int i = 0; i < docs.length; i++) {
                      sum += docs[i]['costo'];
                      print('costo $sum');
                    }

                    final docGeneral = await FirebaseFirestore.instance
                        .collection('CostiGenerali').doc('2022')
                        .collection(uid).where(
                        'mese', isEqualTo: month)
                        .get();
                    var docs1 = docGeneral.docs;
                    double sum1 = 0.0;
                    sum1 += docs1[0]['costo'];


                    final doc1 = await FirebaseFirestore.instance.collection('CostiManutenzione').where('uid', isEqualTo: uid).where('index', isEqualTo: cost.index).get();
                    DocumentReference docu =  doc1.docs[0].reference;
                    docu.update({'costo': newCostoManutenzione, "data": newDate, "note": newNote});

                    //print('somma precedente $sum');

                    //print(sum + (costoAgg!));

                    await FirebaseFirestore.instance.collection(
                        'CostiTotaliManutenzione').doc('2022')
                        .collection(uid)
                        .doc(month)
                        .update({"costoManutenzione": sum + (costoAgg!)});

                    await FirebaseFirestore.instance.collection(
                        'CostiGenerali').doc('2022')
                        .collection(uid)
                        .doc(month)
                        .update({"costo": sum1 + (costoAgg!)});

                  },
                  btnCancelOnPress: () {},
                  btnCancelText: 'Annulla',
                  btnCancelIcon: Icons.cancel_outlined,
                  btnOkIcon: Icons.check_circle,
                ).show()
              },
              icon: Icon(Icons.edit, color: Colors.grey,)
          ),
          ),
        ],
      );

  @override
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
                        'measure': e.data()['costoManutenzione'],
                      };
                    }).toList();
                    //listChart.sort();
                    //listChart.sort((a,b) => a['domain'].compareTo(b['domain']));
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
                     label: Text('Manutenzione', style: TextStyle(color: Colors.white)),
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
                         Navigator.of(context).pushNamed(Manutenzione.routeName);
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
                              Icons.build,
                              size: 25,
                              color: Colors.white,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                            child:
                            Text('Storico Manutenzioni', style: TextStyle(
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
                                          'Note', style: _contentStyleHeader),
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