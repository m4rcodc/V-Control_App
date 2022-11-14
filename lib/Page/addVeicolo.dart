import 'dart:io';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:car_control/Page/home_page.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import '../Widgets/select_photo_options_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:page_transition/page_transition.dart';

class AddVeicolo extends StatefulWidget{

  static const routeName = '/add-veicolo';

  @override
  State<AddVeicolo> createState() => _AddVeicoloState();
}

class _AddVeicoloState extends State<AddVeicolo> {

  //Variabile per il metodo imagePicker
  //XFile? image;

  final GlobalKey<FormState> _formKeyPlate = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyType = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyEngine = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyFuel = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyKm = GlobalKey<FormState>();


  FirebaseAuth auth = FirebaseAuth.instance;

  String? make;
  String? model;
  String? plate;
  String? kilometers;
  String? type;
  String? engine;
  String? fuel;
  var setDefaultMake = true, setDefaultModel = true, setDefaultType = true;

  File? image;
  String? imageUrl;

  void makeSelected(value){
    debugPrint('selected onchange: $value');
    setState(() {
      debugPrint('make selected: $value');
      make = value;
      setDefaultMake = false;
      setDefaultModel = true;
    });
  }

  void modelSelected(value){
    debugPrint('selected onchange: $value');
    setState(() {
      debugPrint('make selected: $value');
      model = value;
      setDefaultModel = false;
    });
  }

  final List<String> ChoiceCilindrata = [
    '1200',
    '1300',
  ];

  final List<String> ChoiceFuel = [
    'Benzina',
    'Diesel',
    'Metano',
    'Gas',
    'Elettrica',
  ];



  String? selectedValue;


  @override
  Widget build(BuildContext context) {
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
            //Plate
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 15.0),
              child: Form(
                key: _formKeyPlate,
                  child:
                TextFormField(
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
                validator: (value){
                  if(value == null || value.isEmpty){
                    return 'Inserisci la targa del veicolo';
                  }
                  else if(value.isNotEmpty && value.length != 6) {
                    return 'La lunghezza della targa deve essere pari a 6';
                  } else {
                    return null;
                    }
                  },
                onChanged: (value) {
                  setState(() {
                    plate = value;
                  });
                },
                ),
                ),
            ),
            //VehicleType
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 15.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('vehicleType')
                    .orderBy('type')
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  if (setDefaultType) {
                    //make = snapshot.data.docs[0].get('nome');
                    debugPrint('setDefault type: $type');
                  }

                return Form(
                  key: _formKeyType,
                      child: DropdownButtonFormField2(
                    decoration: InputDecoration(
                      //Add isDense true and zero Padding.
                      //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
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
                        filled: true,
                        fillColor: Colors.white70
                    ),
                    isExpanded: true,
                    value: type,
                    hint: const Text(
                      'Seleziona tipo di veicolo',
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
                        value: value.get('type'),
                        child: Text(
                          '${value.get('type')}',
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      );
                    }).toList(),
                    validator: (value) {
                      if(value == null) {
                        return 'Seleziona un tipo di veicolo';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      debugPrint('selected onchange: $value');
                        setState(() {
                        debugPrint('make selected: $value');
                        type = value;
                        setDefaultType = false;
                        setDefaultMake = true;
                        setDefaultModel = true;
                      });
                    },
                    /*onSaved: (value) {
                  selectedValue = value.toString();
                },*/
                  ),
                );
                },
              ),
            ),
            //Make
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 15.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Make')
                    .where('type', isEqualTo: type)
                    .orderBy('name')
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  if (setDefaultMake) {
                    //make = snapshot.data.docs[0].get('nome');
                    debugPrint('setDefault make: $make');
                  }

                  return DropdownButtonFormField2(
                    decoration: InputDecoration(
                      //Add isDense true and zero Padding.
                      //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.indigoAccent),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        filled: true,
                        fillColor: Colors.white70
                    ),
                    isExpanded: true,
                    value: make,
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
                      borderRadius: BorderRadius.circular(25),
                    ),
                    items: snapshot.data.docs.map<DropdownMenuItem<String>>((value) {
                      return DropdownMenuItem<String>(
                        value: value.get('name'),
                        child: Text(
                          '${value.get('name')}',
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: setDefaultType ? null : (value) async  =>  makeSelected(value),
                    /*onSaved: (value) {
                  selectedValue = value.toString();
                },*/
                  );
                },
              ),
            ),
            //Model
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 15.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Model')
                    .where('make', isEqualTo: make)
                    .orderBy('model')
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    debugPrint('snapshot status: ${snapshot.error}');
                    return Container(
                      child:
                      Text(
                          'snapshot empty make: $make makeModel: $model'),
                    );
                  }
                  if (setDefaultModel) {
                    //carMake = snapshot.data.docs[0].get('makeModel');
                    debugPrint('setDefault make: $make');
                  }
                  return DropdownButtonFormField2(
                    decoration: InputDecoration(
                      //Add isDense true and zero Padding.
                      //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.indigoAccent),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        filled: true,
                        fillColor: Colors.white70
                    ),
                    isExpanded: true,
                    value: model,
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
                      borderRadius: BorderRadius.circular(25),
                    ),
                    items: snapshot.data.docs.map<DropdownMenuItem<String>>((value) {
                      return DropdownMenuItem<String>(
                        value: value.get('model'),
                        child: Text(
                          '${value.get('model')}',
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged:  setDefaultMake ? null : (value) => modelSelected(value),
                    /*onSaved: (value) {
                  selectedValue = value.toString();
                },*/
                  );
                },
              ),
            ),
            //Cilindrata
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 15.0),
              child:
              Form(
              key: _formKeyEngine,
              child: DropdownButtonFormField2(
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
                  if(value == null) {
                    return 'Selezionare una cilindrata';
                  }
                },
                onChanged: (value) {
                  setState(() {
                    engine = value;
                  });
                },
              ),
              ),
            ),
            //Alimentazione
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 15.0),
              child:
              Form(
              key: _formKeyFuel,
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
                  'Alimentazione',
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
                  borderRadius: BorderRadius.circular(25),
                ),
                items: ChoiceFuel
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
                  if(value == null){
                    return 'Seleziona il tipo di alimentazione del veicolo';
                  }
                },
                onChanged: (value) {
                  setState(() {
                    fuel = value;
                  });
                },
              ),
              ),
            ),
            //Kilometri
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 15.0),
              child:
              Form(
              key: _formKeyKm,
                child:
              TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  hintText: 'Inserisci i kilometri attuali del veicolo',
                  hintStyle: const TextStyle(fontSize: 14),
                  filled: true,
                  fillColor: Colors.white70,
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
                validator: (value) {
                  if(value == null || value.isEmpty){
                    return 'Inserisci i kilometri attuali del veicolo';
                  }
                  else {
                    return null;
                  }
                },
                onChanged: (value) {
                  setState(() {
                    kilometers = value;
                  });
                },
              ),
              ),
            ),
            //ButtonAddVeicolo
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 60.0),
              child: ElevatedButton(
                onPressed: () => {
                  if(image == null) {
                    displayCenterMotionToast()
                  }
                  else if(!_formKeyPlate.currentState!.validate()){
                  }
                  else if(!_formKeyType.currentState!.validate()){
                  }
                  else if(!_formKeyEngine.currentState!.validate()){
                  }
                  else if(!_formKeyFuel.currentState!.validate()){
                  }
                  else if(!_formKeyKm.currentState!.validate()){
                  }
                else{
            FirebaseAuth.instance.authStateChanges().listen((User? user) async {
            //await FirebaseFirestore.instance.collection('users').doc.set({'nome': name, 'cognome': surname, 'email' : email});
            CollectionReference vehicle = await FirebaseFirestore.instance.collection('vehicle');
            //await FirebaseFirestore.instance.collection('vehicle').doc(user?.uid).set({'uid': user?.uid, 'make': carMake, 'model' : carMakeModel, 'plate': plate});
            // Call the user's CollectionReference to add a new user

            vehicle.add({
            'uid': user?.uid, // John Doe
            'make': make, // Stokes and Sons
            'model': model, // 42
            'plate' : plate,
            'kilometers' : kilometers,
            'image' : imageUrl,
            'engine' : engine,
            'fuel' : fuel,
            });

            /*
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoadingScreen()),
            );
            */
            Navigator.of(context).pushNamed(HomePage.routeName);
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Veicolo aggiunto con successo'), backgroundColor: Colors.lightBlue,  )
            );
            })
            }
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

      upload_image();

    } on PlatformException catch(e) {
      print('Failed to pick image: $e');
    }
  }

  void upload_image() async {

    /*if(image == null){
      Fluttertoast.showToast(msg: "Seleziona un immagine");
      return;
    }*/

      final ref = FirebaseStorage.instance.ref().child('userImages').child('User: ${auth.currentUser!.uid}');
      await ref.putFile(image!);
      final imageURL = await ref.getDownloadURL();

      setState(() => imageUrl = imageURL);
  }

  void displayCenterMotionToast() {
    MotionToast(
      icon: Icons.error,
      primaryColor: Colors.deepOrange,
      title: const Text(
        'Errore!',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      width: 350,
      height: 150,
      description: const Text(
        'Per favore inserisci una foto del tuo veicolo',
      ),
      //description: "Center displayed motion toast",
      position: MotionToastPosition.center,
    ).show(context);
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

/*
class LoadingScreen extends StatelessWidget{

  static const routeName = '/splash-screen';

  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return AnimatedSplashScreen(
      splash: Lottie.network('https://assets6.lottiefiles.com/packages/lf20_gv7Ovi.json'),
      backgroundColor: Colors.white,
      nextScreen: HomePage(),
      splashIconSize: 250,
      duration: 2200,
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.fade,
      animationDuration: const Duration(seconds: 1),
    );
  }

}
*/



