import 'package:car_control/Page/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class SignupPage extends StatefulWidget {

  static const routeName = '/signup-page';

  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  final _nameKey = GlobalKey<FormState>();
  final _surnameKey = GlobalKey<FormState>();
  final _emailKey = GlobalKey<FormState>();
  final _passwordKey = GlobalKey<FormState>();
  final _confermaPasswordKey = GlobalKey<FormState>();
  final emailPattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  final passPattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,32}$';

  FirebaseAuth auth = FirebaseAuth.instance;

  String name='';
  String surname='';
  String email='';
  String password='';
  bool emailValid = false;
  bool passValid = false;

  Widget signUpWith(IconData icon) {
    return Container(
      height: 50,
      width: 115,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.4), width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24),
          TextButton(onPressed: () {}, child: Text('Sign in')),
        ],
      ),
    );
  }

  Widget userInput(TextEditingController userInput, String hintTitle,
      TextInputType keyboardType) {
    return Container(
      height: 55,
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
          color: Colors.blueGrey.shade200,
          borderRadius: BorderRadius.circular(30)),
      child: Padding(
        padding: const EdgeInsets.only(left: 25.0, top: 15, right: 25),
        child: TextField(
          controller: userInput,
          autocorrect: false,
          enableSuggestions: false,
          autofocus: false,
          decoration: InputDecoration.collapsed(
            hintText: hintTitle,
            hintStyle: const TextStyle(
                fontSize: 18,
                color: Colors.white70,
                fontStyle: FontStyle.italic),
          ),
          keyboardType: keyboardType,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          decoration:const BoxDecoration(
              color: Color(0xFFE3F2FD)
          ),
          child:
          Container(
            padding: EdgeInsets.all(20),
            child:
            Image.asset(
              'images/RegistrationImage.png',
              width: MediaQuery.of(context).size.width,
              scale: 1.75,
            ),
          ),
        ),
        bottomSheet: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFBBDEFB),
            boxShadow: [
              BoxShadow(
                offset: Offset(0,-3),
                blurRadius: 6,
                color: Colors.black54,
              )
            ],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          height: MediaQuery.of(context).size.height * 0.615,
          //mainAxisAlignment: MainAxisAlignment.end,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 15),
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 25),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25)),
                ),
                child: Form(
                  key: _nameKey,
                  child:
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Inserisci il tuo nome',
                      labelText: 'Nome',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                      prefixIcon: const Icon(Icons.person),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),

                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r"[a-zA-Z]+|\s"),
                      ),],
                    validator: (value) {
                      if (value==null || value.isEmpty) {
                        return 'Il campo "Nome" non può essere vuoto';
                      }
                      else if (value.length > 32)
                      {
                        return 'Il campo "Nome" deve avere lunghezza inferiore a 32 caratteri';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        name = value;
                      });
                    },
                  ),
                ),
              ),

              Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25)),
                ),
                child: Form(
                  key: _surnameKey,
                  child:
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Inserisci il tuo cognome',
                      labelText: 'Cognome',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                      prefixIcon: const Icon(Icons.person),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r"[a-zA-Z]+|\s"),
                      ),],

                    validator: (value) {
                      if (value==null || value.isEmpty) {
                        return 'Il campo "Cognome" non può essere vuoto';
                      }
                      else if (value.length > 32)
                      {
                        return 'Il campo "Cognome" deve avere lunghezza inferiore a 32 caratteri';
                      }
                      return null;
                    },

                    onChanged: (value) {
                      setState(() {
                        surname=value;
                      });
                    },
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25)),
                ),
                child: Form(
                  key: _emailKey,
                  child:
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Inserisci la tua email',
                      labelText: 'Email',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                      prefixIcon: const Icon(Icons.email),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    validator: (value) {
                      if (value==null || value.isEmpty) {
                        return 'Il campo "Email" non può essere vuoto.';
                      }
                      else if (!RegExp(emailPattern).hasMatch(value))
                      {
                        return 'Email non valida.';
                      }
                      return null;
                    },

                    onChanged: (value) {
                      setState(() {

                        if(value.length < 128){
                          email=value;
                        }

                      });
                    },
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25)),
                ),
                child: Form(
                  key: _passwordKey,
                  child:
                  TextFormField(
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Inserisci la password',
                      labelText: 'Password',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                      prefixIcon: const Icon(Icons.lock),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),

                    ),
                    validator: (value) {
                      if (value==null || value.isEmpty) {
                        return 'Il campo "Password" non può essere vuoto.';
                      }

                      else if(value.length < 8 || value.length > 32){
                        return 'Immetere una password di 8-32 caratteri.';
                      }
                      else if (!RegExp(passPattern).hasMatch(value))
                      {
                        return 'Immetere almeno un carattere maiuscolo,\nminuscolo e speciale.';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        if(value.length < 32)
                        {
                          password=value;
                        }

                      });
                    },
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25)),
                ),
                child: Form(
                  key: _confermaPasswordKey,
                  child:
                  TextFormField(
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Reinserisci la tua password',
                      labelText: 'Conferma Password',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                      prefixIcon: const Icon(Icons.lock),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),

                    ),

                    validator: (value) {
                      if (value==null || value.isEmpty) {
                        return 'Il campo "Conferma Password" non può essere vuoto.';
                      }

                      else if(value != password){
                        return 'La password non coincide';
                      }

                      return null;
                    },

                    onChanged: (value) {
                      setState(() {
                        if(value.length < 24)
                        {
                          password=value;
                        }
                      });
                    },
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 120.0),
                child: ElevatedButton(
                  onPressed: () async => {
                    if(!_nameKey.currentState!.validate()){

                    }
                    else if(!_surnameKey.currentState!.validate()){

                    }
                    else if(!_emailKey.currentState!.validate()){

                      }
                      else if(!_passwordKey.currentState!.validate()){

                        }
                        else if(!_confermaPasswordKey.currentState!.validate()){

                          }
                          else {
                              await auth.createUserWithEmailAndPassword(
                                email: email,
                                password: password,
                              ).then((value) {
                                FirebaseFirestore.instance.collection('users').doc(auth.currentUser?.uid).set({'name': name, 'surname': surname, 'email' : email, 'uid' : auth.currentUser?.uid});
                                FirebaseFirestore.instance.collection('community').doc(auth.currentUser?.uid).set({'name': name, 'uid' : auth.currentUser?.uid, 'points' : 0, 'make' : '', 'model' : '', 'fuel' : '', 'image' : 'https://firebasestorage.googleapis.com/v0/b/emad2022-23.appspot.com/o/defaultImage%2FLogoApp.png?alt=media&token=815b924d-e981-4fb6-ad76-483a2f591310'});
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Registrazione effettuata!')),
                                );
                                //Fa il route alla homepage ed elimina tutte le pagine precedenti dallo stack di navigation
                                Navigator.pushNamedAndRemoveUntil(context, HomePage.routeName, (route) => false);
                              }).onError((error, stackTrace) {
                                debugPrint(error.toString());
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Email già in uso!')),
                                );
                              })
                            },
                    //Navigator.of(context).pushNamed(HomePage.routeName);
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
                    child:
                    Text(
                        "Registrati",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        )
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
