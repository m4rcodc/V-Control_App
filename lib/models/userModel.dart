import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{


  String name;
  String surname;
  String email;
  int points;
  String uid;


  UserModel({
    required this.name,
    required this.surname,
    required this.email,
    required this.points,
    required this.uid,

  });

  factory UserModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return UserModel(
      name: data?['name'],
      surname: data?['surname'],
      email: data?['email'],
      points: data?['points'],
      uid : data?['uid'],

    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (surname != null) "surname": surname,
      if (email != null) "email": email,
      if (points != null) "points": points,
      if (uid != null) "uid": uid,

    };

  }


  static UserModel fromJson(Map<String, dynamic> json) => UserModel(
    name: json['name'],
    surname: json['surname'],
    email: json['email'],
    points: json['points'],
    uid: json['uid'],
  );


/*
  static UserModel fromJson(Map<String, dynamic> json) => UserModel(
      name: json['nome'],
      surname: json['cognome'],
      email: json['email'],

  );

*/
}