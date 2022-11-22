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

  final _formKey = GlobalKey<FormState>();
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
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              alignment: Alignment.topCenter,
              fit: BoxFit.fill,
              image: AssetImage(
                'images/addtask.jpg',
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 510,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 45),
                          TextFormField(
                            autofocus: true,
                            textInputAction: TextInputAction.next,

                            decoration: InputDecoration(
                              filled: true,
                              hintText: 'Inserisci il tuo nome',
                              labelText: 'Nome',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                              prefixIcon: const Icon(Icons.person),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 20,
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

                          const SizedBox(height: 8.0),

                          TextFormField(
                            autofocus: true,
                            textInputAction: TextInputAction.next,

                            decoration: InputDecoration(
                              filled: true,
                              hintText: 'Inserisci il tuo cognome',
                              labelText: 'Cognome',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                              prefixIcon: const Icon(Icons.person),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 20,
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

                          const SizedBox(height: 8.0),

                          TextFormField(
                            autofocus: true,
                            textInputAction: TextInputAction.next,

                            decoration: InputDecoration(
                              filled: true,
                              hintText: 'Inserisci la tua email',
                              labelText: 'Email',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                              prefixIcon: const Icon(Icons.email),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 20,
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

                          const SizedBox(height: 8.0),

                          TextFormField(
                            obscureText: true,
                            autofocus: true,
                            textInputAction: TextInputAction.next,

                            decoration: InputDecoration(
                              filled: true,
                              hintText: 'Inserisci la password',
                              labelText: 'Password',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                              prefixIcon: const Icon(Icons.lock),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 20,
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

                          const SizedBox(height: 8.0),

                          TextFormField(
                            obscureText: true,
                            autofocus: true,
                            textInputAction: TextInputAction.next,

                            decoration: InputDecoration(
                              filled: true,
                              hintText: 'Reinserisci la tua password',
                              labelText: 'Conferma Password',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                              prefixIcon: const Icon(Icons.lock),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 20,
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

                          const SizedBox(height: 8.0),


                          Container(
                            height: 55,
                            // for an exact replicate, remove the padding.
                            // pour une réplique exact, enlever le padding.
                            padding:
                            const EdgeInsets.only(top: 5, left: 70, right: 70),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.indigo,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25))),
                              onPressed: () async {


                                if (_formKey.currentState!.validate()) {
                                      await auth.createUserWithEmailAndPassword(
                                      email: email,
                                      password: password,
                                    ).then((value) {
                                      FirebaseFirestore.instance.collection('users').doc(auth.currentUser?.uid).set({'nome': name, 'cognome': surname, 'email' : email});
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
                                    });
                                }
                              },
                              /*print(emailController);
                        print(passwordController);
                        Provider.of<Auth>(context, listen: false).signup(emailController.text, passwordController.text);
                        Navigator.of(context.push(MaterialPageRoute(builder: (ctx) => SuccessfulScreen()));*/
                              child: const Text(
                                'Registrati',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),

                          ),


                        ],
                      ),
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
