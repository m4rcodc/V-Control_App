import 'package:accordion/accordion.dart';
import 'package:accordion/accordion_section.dart';
import 'package:accordion/controllers.dart';
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
  String? year;
  String? fullNameMonth;
  DateTime now = new DateTime.now();
  var formatter = new DateFormat('dd-MM-yyyy');


  final _headerStyle = const TextStyle(
      color: Color(0xffffffff), fontSize: 15, fontWeight: FontWeight.bold);
  final _contentStyleHeader = const TextStyle(
      color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.w700);
  final _contentStyle = const TextStyle(
      color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.normal);

  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  final streamChart = FirebaseFirestore.instance.collection('CostiTotali')
      .doc('2022').collection(FirebaseAuth.instance.currentUser!.uid).orderBy('index', descending: false)
      .snapshots(includeMetadataChanges: true);

  Stream<List<Costs>> readCosts() =>
  FirebaseFirestore.instance
      .collection('CostiRifornimento')
      .where('uid', isEqualTo: uid)
      .where('mese', isEqualTo: month)
      .where('year', isEqualTo: year)
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
              AwesomeDialog(
                context: context,
                headerAnimationLoop: false,
                dialogType: DialogType.noHeader,
                title: 'Attenzione!',
                desc:
                'Sei sicuro di voler procedere con la cancellazione?',
                body:
                Container(
                    height: 340,
                    child:
                    Column(
                      children: [
                        Container(
                            alignment: Alignment.center,
                            child: Text('Modifica data')
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 10.0),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 10,
                                  backgroundColor: Colors.blue,
                                  shape: StadiumBorder()
                              ),
                              onPressed: () async {
                                DateTime? newDate = await showDatePicker(
                                    context: context,
                                    initialDate: now,
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100),
                                    builder: (context, child) {
                                      return Theme(
                                        data: Theme.of(context).copyWith(
                                            colorScheme: const ColorScheme
                                                .light(
                                              primary: Colors.lightBlue,
                                              onPrimary: Colors.white,
                                              onSurface: Colors.blueAccent,
                                            ),
                                            textButtonTheme: TextButtonThemeData(
                                                style: TextButton.styleFrom(
                                                  backgroundColor: Colors
                                                      .lightBlue.shade50,
                                                )
                                            )
                                        ),
                                        child: child!,
                                      );
                                    }
                                );
                                if (newDate == null) return;
                                setState(() => now = newDate);
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.calendar_month),
                                    Text("Data rifornimento: ${formatter.format(
                                        now)}")
                                  ],
                                ),
                              )
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 20),
                            alignment: Alignment.center,
                            child: Text('Modifica costo rifornimento')
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
                              labelText: 'Costo rifornimento',
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
                                //costoRifornimento = double.tryParse(value);
                              });
                            },
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 20),
                            alignment: Alignment.center,
                            child: Text('Modifica litri')
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
                              labelText: 'Litri',
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
                                //costoRifornimento = double.tryParse(value);
                              });
                            },
                          ),
                        ),
                      ],
                    )

                ),
                btnOkOnPress: () {},
                btnCancelOnPress: () {},
                btnCancelText: 'Cancella',
                btnCancelIcon: Icons.cancel_outlined,
                btnOkIcon: Icons.check_circle,
              ).show()
            },
            icon: Icon(Icons.edit, color: Colors.grey,))
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
                    onPressed: () {
                      Navigator.of(context).pushNamed(Carburante.routeName);
                    },
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
              child: Accordion(
                maxOpenSections: 2,
                headerBackgroundColorOpened: Colors.black54,
                scaleWhenAnimating: true,
                openAndCloseAnimation: true,
                headerPadding:
                const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
                sectionClosingHapticFeedback: SectionHapticFeedback.light,
                children: [
                  AccordionSection(
                      isOpen: true,
                      leftIcon: const Icon(
                          Icons.local_gas_station, color: Colors.white),
                      header: Text('Storico rifornimenti', style: _headerStyle),
                      content:
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
