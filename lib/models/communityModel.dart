import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityModel {

  String? make;
  String? model;
  String? uid;
  String? image;
  String? fuel;
  String? name;
  int? points;


  CommunityModel({
    required this.make,
    required this.model,
    required this.uid,
    required this.image,
    required this.fuel,
    required this.points,
    required this.name
  });

  static CommunityModel fromJson(Map<String, dynamic> json) => CommunityModel(
    make: json['make'],
    model: json['model'],
    uid: json['uid'],
    image: json['image'],
    name: json['name'],
    fuel: json['fuel'],
    points: json['points'],
  );




}