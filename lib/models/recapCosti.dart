class RecapCosti {

  String? mese;
  double? costo;
  double? totaleLitri;


  RecapCosti({

    required this.mese,
    required this.costo,
    required this.totaleLitri

  });

  static RecapCosti fromJson(Map<String, dynamic> json) => RecapCosti(

      mese: json['mese'],
      costo: json['costo'],
      totaleLitri: json['totaleLitri']
  );


}