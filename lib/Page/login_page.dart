import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:car_control/Page/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'dart:convert' show JsonEncoder, json;
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'home_page.dart';
import 'package:page_transition/page_transition.dart';

/*
GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  clientId: "1097648256893-jjbeembce6fed4ar22m5dn3kjhqsmh8o.apps.googleusercontent.com",
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);
*/



class LoginPage extends StatefulWidget {

  static const routeName = '/login-screen';

  const LoginPage({super.key});

  _LoginPageState createState() => _LoginPageState();


}

class _LoginPageState extends State<LoginPage> {

  final _formKey = GlobalKey<FormState>();
  final emailPattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  final passPattern = "^(?=.*d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,24}\$";


  String _contactText = '';


  String email='';
  String password='';
  bool emailValid = false;
  bool passValid = false;
  var credential;

/*
  GoogleSignInAccount? _currentUser;
  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        _handleGetContact(_currentUser!);
      }
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _handleGetContact(GoogleSignInAccount user) async {
    setState(() {
      _contactText = 'Loading contact info...';
    });
    final http.Response response = await http.get(
      Uri.parse('https://people.googleapis.com/v1/people/me/connections'
          '?requestMask.includeField=person.names'),
      headers: await user.authHeaders,
    );
    if (response.statusCode != 200) {
      setState(() {
        _contactText = 'People API gave a ${response.statusCode} '
            'response. Check logs for details.';
      });
      debugPrint('People API ${response.statusCode} response: ${response.body}');
      return;
    }
    final Map<String, dynamic> data =
    json.decode(response.body) as Map<String, dynamic>;
    final String? namedContact = _pickFirstNamedContact(data);
    setState(() {
      if (namedContact != null) {
        _contactText = 'I see you know $namedContact!';
      } else {
        _contactText = 'No contacts to display.';
      }
    });
  }

  String? _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic>? connections = data['connections'] as List<dynamic>?;
    final Map<String, dynamic>? contact = connections?.firstWhere(
          (dynamic contact) => contact['names'] != null,
      orElse: () => null,
    ) as Map<String, dynamic>?;
    if (contact != null) {
      final Map<String, dynamic>? name = contact['names'].firstWhere(
            (dynamic name) => name['displayName'] != null,
        orElse: () => null,
      ) as Map<String, dynamic>?;
      if (name != null) {
        return name['displayName'] as String?;
      }
    }
    return null;
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

*/


  Widget login(IconData icon)
  {
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
          TextButton(onPressed: () {}, child: const Text('Sign in')),
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
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
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
                                hintText: 'Inserisci la tua email',
                                labelText: 'Email',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                prefixIcon: const Icon(Icons.email),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 20,
                                ),


                              ),


                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Il campo "Email" non può essere vuoto.';
                                }
                                else
                                if (!RegExp(emailPattern).hasMatch(value) ||
                                    value == 'adminadmin') {
                                  return 'Email non valida.';
                                }
                                return null;
                              },

                              onChanged: (value) {
                                setState(() {
                                  if (value.length < 64) {
                                    email = value;
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
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                prefixIcon: const Icon(Icons.lock),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 20,
                                ),

                              ),


                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Il campo "Password" non può essere vuoto.';
                                }

                                else
                                if (value.length < 8 || value.length > 16) {
                                  return 'Password errata.';
                                }

                               /*
                                else if (!RegExp(passPattern).hasMatch(value)) {
                                  return 'Password errata.';
                                }
                              */
                                return null;
                              },

                              onChanged: (value) {
                                setState(() {
                                  if (value.length < 16) {
                                    password = value;
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
                              const EdgeInsets.only(
                                  top: 5, left: 70, right: 70),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.indigo,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            25))),
                                onPressed: () {

                                  //Navigator.of(context).pushNamed(HomePage.routeName);

                                  if (_formKey.currentState!.validate()) {
                                    try {
                                      credential = FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password,);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const LoadingScreen()),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                          const SnackBar(content: Text(
                                              'Login effettuato!')));
                                    } on FirebaseAuthException catch (e) {
                                      if (e.code == 'user-not-found') {
                                        debugPrint(
                                            'No user found for that email.');

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                            const SnackBar(content: Text(
                                                'Utente non trovato!')));
                                      } else if (e.code == 'wrong-password') {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                            const SnackBar(content: Text(
                                                'Email o Password errati!')));
                                      }




                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text('Login Effettuato!')),
                                      );
                                    }
                                  }
                                },


                                child: const Text(
                                  'Accedi',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Center(
                              child: Text('Password dimenticata ?'),),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.only(top: 25.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceEvenly,
                                children: [
                                  SignInButton(
                                    Buttons.Google,
                                    text: "Accedi con Google",
                                    onPressed: (){},




                                  ),
                                  SignInButton(
                                    Buttons.Facebook,
                                    text: 'Accedi con Facebook',
                                    onPressed: () {},

                                  ),
                                  SignInButton(
                                    Buttons.Email,
                                    text: "Registrati con email",
                                    onPressed: () {
                                      Navigator.of(context).pushNamed(
                                          SignupPage.routeName);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const Divider(thickness: 0, color: Colors.white),

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

class LoadingScreen extends StatelessWidget{

  static const routeName = '/splash-screen';

  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return AnimatedSplashScreen(
      splash: Lottie.network('https://assets6.lottiefiles.com/packages/lf20_hslwihoj.json'),
      backgroundColor: Colors.lightBlue.shade100,
      nextScreen: HomePage(),
      splashIconSize: 250,
      duration: 2200,
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.fade,
      animationDuration: const Duration(seconds: 1),
    );
  }

}

