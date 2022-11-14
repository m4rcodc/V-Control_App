import 'package:accordion/accordion.dart';
import 'package:accordion/accordion_section.dart';
import 'package:accordion/controllers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_chart/d_chart.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:car_control/models/costs.dart';


class CostiRifornimento extends StatefulWidget {

  @override
  CostiRifornimentoState createState() => CostiRifornimentoState();

}

class CostiRifornimentoState extends State<CostiRifornimento> {

  String? year;

  final List<String> ChoiceYear = [
    '2022',
    '2023',
  ];

  final List<String> items = ['Gennaio','Febbraio','Marzo','Aprile','Maggio'];
  String? selectedValue;

  final _headerStyle = const TextStyle(
      color: Color(0xffffffff), fontSize: 15, fontWeight: FontWeight.bold);
  final _contentStyleHeader = const TextStyle(
      color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.w700);
  final _contentStyle = const TextStyle(
      color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.normal);

  @override
  final streamChart = FirebaseFirestore.instance.collection('costi')
      .doc('2022').collection('Cost').orderBy('index', descending: false)
      .snapshots(includeMetadataChanges: true);

  String uid = FirebaseAuth.instance.currentUser!.uid;


  Stream<List<Costs>> readCosts() =>
      FirebaseFirestore.instance
          .collection('CostiRifornimento')
          .where('uid', isEqualTo: uid)
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
          DataCell(Text('${cost.costo}', style: _contentStyle)),
          DataCell(Text('${cost.litri}',
              style: _contentStyle,
              textAlign: TextAlign.right))
        ],
      );


  Widget build(BuildContext context) {

    return Scaffold(
      body:
      Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.lightBlue, Colors.white],
            )
        ),

        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 200, horizontal: 10),
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: StreamBuilder(
                  stream: streamChart,
                  builder: (context, AsyncSnapshot<
                      QuerySnapshot<Map<String, dynamic>>> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }
                    if (snapshot.data == null) {
                      return const Text("Empty");
                    }
                    List<Map<String, dynamic>> listChart = snapshot.data!.docs
                        .map((e) {
                      return {
                        'domain': e.data()['mese'],
                        'measure': e.data()['costo'],
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
                        axisLineColor: Colors.white70,
                        barColor: (barData, index, id) => Colors.white70,
                        showBarValue: true,
                      ),
                    );
                  }
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 25.0,horizontal: 15.0),
                child:
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6.0),
                      child:
                      Row(
                    children : [
                        Expanded(
                    child:
                  DropdownButtonFormField2(
                  decoration: InputDecoration(
                    //Add isDense true and zero Padding.
                    //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
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
                      filled: true,
                      fillColor: Colors.white70
                  ),
                  isExpanded: true,
                  hint: const Text(
                    'Filtra per mese',
                    style: TextStyle(fontSize: 14),
                  ),
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black45,
                  ),
                  iconSize: 30,
                  buttonHeight: 40,
                  buttonPadding: const EdgeInsets.only(left: 20, right: 10),
                  dropdownDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  items: items
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
                    if(value == null) {
                      return 'Selezionare una cilindrata';
                    }
                  },
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value;
                    });
                  },
                ),
                  ),

                  Expanded(
                    child:
                    DropdownButtonFormField2(
                      decoration: InputDecoration(
                        //Add isDense true and zero Padding.
                        //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
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
                          filled: true,
                          fillColor: Colors.white70
                      ),
                      isExpanded: true,
                      hint: const Text(
                        'Filtra per mese',
                        style: TextStyle(fontSize: 14),
                      ),
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black45,
                      ),
                      iconSize: 30,
                      buttonHeight: 40,
                      buttonPadding: const EdgeInsets.only(left: 20, right: 10),
                      dropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      items: items
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
                        if(value == null) {
                          return 'Selezionare una cilindrata';
                        }
                      },
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value;
                        });
                      },
                    ),
                  ),
                ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Accordion(
                maxOpenSections: 2,
                headerBackgroundColorOpened: Colors.black54,
                scaleWhenAnimating: true,
                openAndCloseAnimation: true,
                headerPadding:
                const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
                sectionClosingHapticFeedback: SectionHapticFeedback.light,
                children: [
                  AccordionSection(
                      isOpen: false,
                      leftIcon: const Icon(
                          Icons.local_gas_station, color: Colors.white),
                      header: Text('Storico rifornimenti', style: _headerStyle),
                      content:
                      StreamBuilder<List<Costs>>(
                        stream: readCosts(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final cost = snapshot.data!;
                            return DataTable(
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
                              ],
                              //shrinkWrap: true,
                              rows:
                              cost.map(buildTableCosts).toList(),

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
}