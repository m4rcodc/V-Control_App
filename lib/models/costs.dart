class Costs {

  double? costo;
  String? data;
  String? type;
  String? uid;
  double? litri;
  String? mese;
  double? index;
  String? note;
  String? year;

  Costs({
    required this.costo,
    required this.data,
    required this.type,
    required this.uid,
    required this.litri,
    required this.mese,
    required this.index,
    required this.note,
    required this.year
  });

  static Costs fromJson(Map<String, dynamic> json) => Costs(

      costo: json['costo'],
      data: json['data'],
      type: json['type'],
      uid: json['uid'],
      litri: json['litri'],
      mese: json['mese'],
      index: json['index'],
      note: json['note'],
      year: json['year']

  );


}