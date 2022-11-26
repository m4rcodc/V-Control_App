import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{


  String name;
  String surname;
  String email;
  int points;


  UserModel({
    required this.name,
    required this.surname,
    required this.email,
    required this.points,

  });




  factory UserModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return UserModel(
      name: data?['nome'],
      surname: data?['cognome'],
      email: data?['email'],
      points: data?['points'],

    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "nome": name,
      if (surname != null) "cognome": surname,
      if (email != null) "email": email,
      if (points != null) "points": points,
    };


  }













/*
  static UserModel fromJson(Map<String, dynamic> json) => UserModel(
      name: json['nome'],
      surname: json['cognome'],
      email: json['email'],

  );

*/
}