class RecapCosti {

  String? mese;
  double? litri;
  double? manutenzione;
  double? rifornimento;
  double? costo;
  String? year;


  RecapCosti({

    required this.mese,
    required this.litri,
    required this.manutenzione,
    required this.rifornimento,
    required this.costo,
    required this.year

  });

  static RecapCosti fromJson(Map<String, dynamic> json) => RecapCosti(

      mese: json['mese'],
      litri: json['totaleLitri'],
      manutenzione: json['costoManutenzione'],
      rifornimento: json['costoRifornimento'],
      costo: json['costo'],
      year: json['year']
  );


}