import 'dart:async';

import 'package:car_control/Page/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'signup_page.dart';

class WelcomePage extends StatefulWidget {

  static const routeName = '/welcome-page';

  const WelcomePage({super.key});

  State<StatefulWidget> createState() {
    return StartState();
  }
}

class StartState extends State<WelcomePage> {

  @override
  void initState(){
    super.initState();
    startTimer();
  }

  startTimer() async {
    var duration = const Duration(seconds: 4);
    return Timer(duration, route);
  }

  route() {
    if(FirebaseAuth.instance.currentUser != null)
      {
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => HomePage()
        )
        );
      }
    else {
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => LoginPage()));
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/welcome.jpg'),
                  fit: BoxFit.fill),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 6,
                  //padding: const EdgeInsets.only(top: 35, left: 25),
                  child: Align(
                      alignment: Alignment.topCenter,
                    child:
                      Image.asset('images/LogoApp.png', scale: 3)
                  ),
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 45),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 5),
                      //padding: const EdgeInsets.only(top: 25, left: 24, right: 24),
                        child: const Text(
                          textAlign: TextAlign.center,
                          'Powered By',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,),
                        ),
                      ),
                    Container(
                      child: Image.asset('images/logoAtos.png', scale: 1.8,)
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
