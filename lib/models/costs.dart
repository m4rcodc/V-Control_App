class Costs {

  double? costo;
  String? data;
  String? type;
  String? uid;
  String? litri;
  String? mese;

  Costs({
    required this.costo,
    required this.data,
    required this.type,
    required this.uid,
    required this.litri,
    required this.mese,
  });

  static Costs fromJson(Map<String, dynamic> json) => Costs(

      costo: json['costo'],
      data: json['data'],
      type: json['type'],
      uid: json['uid'],
      litri: json['litri'],
      mese: json['mese']

  );


}