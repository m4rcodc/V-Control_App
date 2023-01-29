import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:car_control/Page/resetPassword.dart';
import 'package:car_control/Page/signup_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'home_page.dart';
import 'package:page_transition/page_transition.dart';





class LoginPage extends StatefulWidget {

  static const routeName = '/login-screen';

  const LoginPage({super.key});

  _LoginPageState createState() => _LoginPageState();


}

class _LoginPageState extends State<LoginPage> {

  final _formKey = GlobalKey<FormState>();
  final emailPattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  final passPattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,32}$';



  String _contactText = '';


  String email='';
  String password='';
  bool emailValid = false;
  bool passValid = false;
  var credential;



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
                  height: MediaQuery.of(context).size.height * 0.71,
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
                            Container(
                                  alignment: Alignment.center,
                                  child:
                                  Image.asset('images/LogoApp.png', scale: 5),

                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              //autofocus: true,
                              //textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor:  Colors.lightBlue.shade50,
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

                            const SizedBox(height: 28.0),

                            TextFormField(
                              obscureText: true,
                              autofocus: true,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor:  Colors.lightBlue.shade50,
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
                              onFieldSubmitted: (value) {
                                FocusScope.of(context).unfocus();
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Il campo "Password" non può essere vuoto.';
                                }

                                else
                                if (value.length < 8 || value.length > 16) {
                                  return 'Password errata.';
                                }

                                else if (!RegExp(passPattern).hasMatch(value)) {
                                  return 'Password errata.';
                                }

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

                            const SizedBox(height: 25.0),

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
                                  if (_formKey.currentState!.validate()) {
                                    credential = FirebaseAuth.instance
                                        .signInWithEmailAndPassword(
                                      email: email, password: password,).then((
                                        value) {

                                      Navigator.pushReplacement(context, MaterialPageRoute(
                                          builder: (context) => HomePage()
                                      )
                                      );

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text('Login Effettuato!')),
                                      );
                                    }).onError((error, stackTrace) {
                                      debugPrint(
                                          "Login Fallito! ${error.toString()}");
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                          const SnackBar(content: Text(
                                              'Email o Password errati!')));
                                    });
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
                             Center(
                              child: RichText(
                                  text: TextSpan(
                                    text: 'Password dimenticata? ',
                                    style: TextStyle(
                                      color: Colors.black54
                                    ),
                                    children: <TextSpan> [
                                      TextSpan(
                                        text: 'Clicca qui!',
                                          recognizer: TapGestureRecognizer()..onTap = () {
                                            Navigator.of(context).push(MaterialPageRoute(
                                                builder: (context) => ResetPassword()));
                                          },
                                          style: TextStyle (
                                          color: Colors.blue,
                                        )
                                      )
                                    ]
                                  )
                              ),
                             ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceEvenly,
                                children: [
                                  SignInButton(
                                    Buttons.Google,
                                    text: "Accedi con Google",
                                    onPressed: () async{
                                      // Trigger the authentication flow
                                      final GoogleSignInAccount? googleUser = await GoogleSignIn(
                                          scopes: <String>["email"]).signIn();

                                      // Obtain the auth details from the request
                                      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

                                      // Create a new credential
                                      final credential = GoogleAuthProvider.credential(
                                          accessToken: googleAuth.accessToken,
                                          idToken: googleAuth.idToken
                                      );



                                      FirebaseAuth.instance.fetchSignInMethodsForEmail(googleUser.email);

                                      bool? isNewUser;

                                      await FirebaseAuth.instance.signInWithCredential(credential).then((value) {
                                        isNewUser = value.additionalUserInfo?.isNewUser;
                                      });

                                     // debugPrint("User nuovo? ${isNewUser.toString()}");

                                     // debugPrint("Il nome è ${googleUser.displayName}, l'email è ${googleUser.email} l'id token è ${FirebaseAuth.instance.currentUser?.uid}");

                                      if(isNewUser!)
                                        {
                                          FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).set({'name': googleUser.displayName, 'email' : googleUser.email, 'uid' : FirebaseAuth.instance.currentUser?.uid});
                                          FirebaseFirestore.instance.collection('community').doc(FirebaseAuth.instance.currentUser?.uid).set({'name': googleUser.displayName, 'uid' : FirebaseAuth.instance.currentUser?.uid, 'points' : 0, 'make' : '', 'model' : '', 'fuel' : '', 'image' : googleUser.photoUrl});
                                        }

                                      Navigator.pushNamedAndRemoveUntil(context, HomePage.routeName, (route) => false);

                                    }
                                  ),
                                  SizedBox(height: 10),
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

