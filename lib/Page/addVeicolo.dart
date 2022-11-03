import 'dart:io';
import 'package:car_control/Page/home_page.dart';
import 'package:car_control/Page/veicolo.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../Widgets/select_photo_options_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddVeicolo extends StatefulWidget{

  static const routeName = '/add-veicolo';

  @override
  State<AddVeicolo> createState() => _AddVeicoloState();
}

class _AddVeicoloState extends State<AddVeicolo> {

  //Variabile per il metodo imagePicker
  //XFile? image;



  var carMake, carMakeModel,plate;
  var setDefaultMake = true, setDefaultMakeModel = true;

  File? image;

  final List<String> ChoiceItems = [
    'Auto',
    'Moto',
  ];

  final List<String> ChoiceMarca = [
    'Ferrari',
    'Fiat',
  ];

  final List<String> ChoiceModello = [
    'SF90',
    'Purosangue',
  ];

  final List<String> ChoiceCilindrata = [
    '1200',
    '1300',
  ];


  String? selectedValue;

  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    //debugPrint('carMake: $carMake');
    //debugPrint('carMakeModel: $carMakeModel');
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Nuovo veicolo'),
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
        child: ListView(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 15.0),
                  child: CircleAvatar(
                    radius: 71.0,
                    backgroundColor: Colors.white70,
                    child: CircleAvatar(
                      radius: 65.0,
                      backgroundColor: Colors.black12,
                      backgroundImage: image == null ? null : FileImage(File(image!.path)),
                      child: image == null
                          ? Icon(
                        Icons.add_photo_alternate,
                        color:Colors.grey,
                        size: MediaQuery.of(context).size.width * 0.20,
                      ) : null,
                    )
                    ,
                  ),
                ),
                Positioned(
                  top: 120,
                  right: 120,
                  child: RawMaterialButton(
                    elevation: 10,
                    fillColor: Colors.white70,
                    child: Icon(Icons.add_a_photo),
                    padding: EdgeInsets.all(14.0),
                    shape: CircleBorder(),
                    onPressed: () {
                      //pickMedia(ImageSource.camera);
                      showSelectPhotoOptions(context);
                    },
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 15.0),
              child: TextFormField(
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  hintText: 'Inserisci la targa del veicolo',
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
                onChanged: (value) {
                  setState(() {
                    plate = value;
                  });
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 15.0),
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
                  'Seleziona Veicolo',
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
                items: ChoiceItems
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
                    return 'Seleziona un veicolo.';
                  }
                },
                onChanged: (value) {
                  //Do something when changing the item if you want.
                },
                onSaved: (value) {
                  selectedValue = value.toString();
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 15.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('carMake')
                    .orderBy('nome')
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  if (setDefaultMake) {
                    //carMake = snapshot.data.docs[0].get('nome');
                    debugPrint('setDefault make: $carMake');
                  }
                  return DropdownButtonFormField2(
                    decoration: InputDecoration(
                      //Add isDense true and zero Padding.
                      //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.indigoAccent),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        filled: true,
                        fillColor: Colors.white70
                    ),
                    isExpanded: true,
                    value: carMake,
                    hint: const Text(
                      'Marca',
                      style: TextStyle(fontSize: 14),
                    ),
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black45,
                    ),
                    iconSize: 30,
                    buttonHeight: 60,
                    buttonPadding: const EdgeInsets.only(
                        left: 20, right: 10),
                    dropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    items: snapshot.data.docs.map<DropdownMenuItem<String>>((value) {
                      return DropdownMenuItem<String>(
                        value: value.get('nome'),
                        child: Text(
                          '${value.get('nome')}',
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == null) {
                        return 'Seleziona un veicolo.';
                      }
                    },
                    onChanged: (value) {
                      debugPrint('selected onchange: $value');
                      setState(() {
                        debugPrint('make selected: $value');
                        carMake = value;
                        setDefaultMake = false;
                        setDefaultMakeModel = true;
                      });
                    },
                    /*onSaved: (value) {
                  selectedValue = value.toString();
                },*/
                  );
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 15.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('carModel')
                    .where('make', isEqualTo: carMake)
                    .orderBy('makeModel')
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    debugPrint('snapshot status: ${snapshot.error}');
                    return Container(
                      child:
                      Text(
                          'snapshot empty carMake: $carMake makeModel: $carMakeModel'),
                    );
                  }
                  if (setDefaultMakeModel) {
                    //carMake = snapshot.data.docs[0].get('makeModel');
                    debugPrint('setDefault make: $carMake');
                  }
                  return DropdownButtonFormField2(
                    decoration: InputDecoration(
                      //Add isDense true and zero Padding.
                      //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.indigoAccent),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        filled: true,
                        fillColor: Colors.white70
                    ),
                    isExpanded: true,
                    value: carMakeModel,
                    hint: const Text(
                      'Modello',
                      style: TextStyle(fontSize: 14),
                    ),
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black45,
                    ),
                    iconSize: 30,
                    buttonHeight: 60,
                    buttonPadding: const EdgeInsets.only(
                        left: 20, right: 10),
                    dropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    items: snapshot.data.docs.map<DropdownMenuItem<String>>((value) {
                      return DropdownMenuItem<String>(
                        value: value.get('makeModel'),
                        child: Text(
                          '${value.get('makeModel')}',
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == null) {
                        return 'Seleziona un veicolo.';
                      }
                    },
                    onChanged: (value) {
                      debugPrint('selected onchange: $value');
                      setState(() {
                        debugPrint('make selected: $value');
                        carMakeModel = value;
                        setDefaultMakeModel = false;
                      });
                    },
                    /*onSaved: (value) {
                  selectedValue = value.toString();
                },*/
                  );
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 15.0),
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
                  'Cilindrata',
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
                items: ChoiceCilindrata
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
                    return 'Seleziona una cilindrata';
                  }
                },
                onChanged: (value) {
                  //Do something when changing the item if you want.
                },
                onSaved: (value) {
                  selectedValue = value.toString();
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 60.0),
              child: ElevatedButton(
                onPressed: () => {
                FirebaseAuth.instance.authStateChanges().listen((User? user) async {
                //await FirebaseFirestore.instance.collection('users').doc.set({'nome': name, 'cognome': surname, 'email' : email});
                CollectionReference vehicle = FirebaseFirestore.instance.collection('vehicle');
                // Call the user's CollectionReference to add a new user
                vehicle.add({
                'uid': user?.uid, // John Doe
                'make': carMake, // Stokes and Sons
                'model': carMakeModel, // 42
                'plate' : plate,
                });
                Navigator.of(context).pushNamed(HomePage.routeName);
                })
                },
                style: ElevatedButton.styleFrom(
                  elevation: 10,
                  backgroundColor: Colors.blue.shade200,
                  shape: const StadiumBorder(),

                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 6,
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
                        width: 14,
                      ),
                      Text(
                        "Aggiungi veicolo",
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
        ),
      ),
    );
  }




  Future pickMedia(ImageSource source) async {
    //XFile? file;
    try {
      final image = await ImagePicker().pickImage(source: source);

      if (image == null) return;

      final imageTemp = File(image.path);

      setState(() => this.image = imageTemp);
    } on PlatformException catch(e) {
      print('Failed to pick image: $e');
    }
  }

/*
      void pickMedia(ImageSource source) async {
    //XFile? file;
      image = await ImagePicker().pickImage(source: source);
  }
*/
  //Button del widget di supporto
  void showSelectPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.28,
          maxChildSize: 0.4,
          minChildSize: 0.28,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: SelectPhotoOptionsScreen(
                onTap: pickMedia,
              ),
            );
          }),
    );
  }


}
