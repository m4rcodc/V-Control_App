import 'package:car_control/Page/AddAssicurazione.dart';
import 'package:car_control/Page/AddBollo.dart';
import 'package:car_control/Page/AddRevisione.dart';
import 'package:car_control/Page/AddTagliando.dart';
import 'package:car_control/Page/Costi.dart';
import 'package:car_control/Page/CostiRifornimento.dart';
import 'package:car_control/Page/Manutenzione.dart';
import 'package:car_control/Page/signup_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Page/addVeicolo.dart';
import 'Page/resetPassword.dart';
import 'Page/welcome_page.dart';
import 'Page/login_page.dart';
import 'Page/home_page.dart';
import 'Page/AddScadenza.dart';
import 'Page/Carburante.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: Colors.cyan.shade100),
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('it', 'IT'),
      ],
      home: WelcomePage(),
      routes: {
        WelcomePage.routeName: (context) => WelcomePage(),
        SignupPage.routeName: (context) => SignupPage(),
        LoginPage.routeName: (context) => LoginPage(),
        HomePage.routeName: (context) => HomePage(),
        AddVeicolo.routeName: (context) => AddVeicolo(),
        AddScadenza.routeName: (context) => AddScadenza(),
        Carburante.routeName: (context) => Carburante(),
        Manutenzione.routeName: (context) => Manutenzione(),
        AddAssicurazione.routeName: (context) => AddAssicurazione(),
        AddTagliando.routeName: (context) => AddTagliando(),
        AddBollo.routeName: (context) => AddBollo(),
        AddRevisione.routeName: (context) => AddRevisione(),
        Costi.routeName: (context) => Costi(0),
        CostiRifornimento.routeName: (context) => CostiRifornimento(),
        ResetPassword.routeName: (context) => ResetPassword()

      },
    );
  }
}
