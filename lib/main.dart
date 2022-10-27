import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Page/addVeicolo.dart';
import 'Page/welcome_page.dart';
import 'Page/login_page.dart';
import 'Page/signup_page.dart';
import 'Page/home_page.dart';
import 'Page/AddScadenza.dart';
import 'Page/Carburante.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  FirebaseApp defaultApp = await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WelcomePage(),
      routes: {
        WelcomePage.routeName: (context) => WelcomePage(),
        SignupPage.routeName: (context) => SignupPage(),
        LoginPage.routeName: (context) => LoginPage(),
        HomePage.routeName: (context) => HomePage(),
        AddVeicolo.routeName: (context) => AddVeicolo(),
        AddScadenza.routeName: (context) => AddScadenza(),
        Carburante.routeName: (context) => Carburante(),
      },
    );
  }
}