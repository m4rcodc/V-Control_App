import 'package:cloud_firestore/cloud_firestore.dart';

class Vehicle {

  String? make;
  String? model;
  String? uid;
  String? image;
  int? kilometers;
  String? fuel;
  String? logoImage;
  String? imageFuelUrl;
  int? numberDocument;

  Vehicle({
    required this.make,
    required this.model,
    required this.uid,
    required this.image,
    required this.kilometers,
    required this.fuel,
    required this.logoImage,
    required this.imageFuelUrl


  });

  static Vehicle fromJson(Map<String, dynamic> json) => Vehicle(
      make: json['make'],
      model: json['model'],
      uid: json['uid'],
      image: json['image'],
      kilometers: json['kilometers'],
      fuel: json['fuel'],
      logoImage: json['logoImage'],
      imageFuelUrl: json['imageFuelUrl']
  );


}