import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ResetPassword extends StatefulWidget {

  static const routeName = '/reset-password';

  const ResetPassword({super.key});

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {

  final emailPattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();



  FirebaseAuth auth = FirebaseAuth.instance;

  String name='';
  String surname='';
  String email='';
  String password='';
  bool emailValid = false;
  bool passValid = false;

  Future resetPassword() async {

    if(!formKey.currentState!.validate()){

    }
    else {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Center(child: CircularProgressIndicator())
      );

      try {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: emailController.text.trim());

        //Utils.showSnackBar('E\' stata inviata un\'email all\'indirizzo inserito');
        var nav = Navigator.of(context);
        nav.pop();
        nav.pop();
      } on FirebaseAuthException catch (e) {
        print(e);

        //Utils.showSnackBar(e.message);
        Navigator.of(context).pop();
      }
    }
  }


    @override
    Widget build(BuildContext context) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
          extendBody: true,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Colors.blue.shade300, // <-- SEE HERE
            ),
            title: Text('Reset Password',
                style: TextStyle(color: Colors.blue.shade300)),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            //toolbarHeight: 55,
          ),
        body: Container(
          decoration: const BoxDecoration(
              color: Color(0xFFE3F2FD)
          ),
          child:
          Container(
            margin: EdgeInsets.only(top: MediaQuery
                .of(context)
                .size
                .height * 0.075),
            //padding: EdgeInsets.all(0),
            child:
            Image.asset(
              'images/ResetPasswod.png',
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              scale: 1.50,
            ),
          ),
        ),
        bottomSheet: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFBBDEFB),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, -3),
                  blurRadius: 6,
                  color: Colors.black54,
                )
              ],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            height: MediaQuery
                .of(context)
                .size
                .height * 0.565,
            //mainAxisAlignment: MainAxisAlignment.end,
            child: Form(
              key: formKey,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 35, horizontal: 20),
                        child:
                      Text(
                        'Inserisci l\'email per effettuare il reset della password', textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w500),
                      ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 45, horizontal: 20),
                        child:
                      TextFormField(
                        controller: emailController,
                        cursorColor: Colors.white,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                            labelText: 'Email',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30)),
                          prefixIcon: const Icon(Icons.email),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
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
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value==null || value.isEmpty) {
                            return 'Inserisci l\'email.';
                          }
                          else if (!RegExp(emailPattern).hasMatch(value))
                          {
                            return 'Email non valida.';
                          }
                          return null;
                        },
                      ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                        child:
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size.fromHeight(50),
                          elevation: 6,
                          backgroundColor: Colors.blue.shade200,
                          shape: const StadiumBorder(),
                        ),
                        icon: Icon(Icons.email_outlined),
                        label: Text(
                          'Reset Password',
                          style: TextStyle(fontSize: 24),
                        ),
                        onPressed: resetPassword,
                      ),
                      ),
                    ],
                  )
              ),
            )
        );
    }
}