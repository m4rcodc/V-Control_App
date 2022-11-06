class Vehicle {

  String? make;
  String? model;
  String? plate;
  String? uid;
  String? image;
  String? kilometers;
  String? engine;
  String? fuel;

  Vehicle({
    required this.make,
    required this.model,
    required this.plate,
    required this.uid,
    required this.image,
    required this.kilometers,
    required this.engine,
    required this.fuel,

});

  static Vehicle fromJson(Map<String, dynamic> json) => Vehicle(
    make: json['make'],
    model: json['model'],
    plate: json['plate'],
    uid: json['uid'],
    image: json['image'],
    kilometers: json['kilometers'],
    engine: json['engine'],
    fuel: json['fuel']
  );

}