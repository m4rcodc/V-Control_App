class RecapCosti {

  String? mese;
  double? costo;
  double? totaleLitri;
  double? manutenzione;
  double? rifornimento;


  RecapCosti({

    required this.mese,
    required this.costo,
    required this.totaleLitri,
    required this.manutenzione,
    required this.rifornimento

  });

  static RecapCosti fromJson(Map<String, dynamic> json) => RecapCosti(

      mese: json['mese'],
      costo: json['costo'],
      totaleLitri: json['totaleLitri'],
      manutenzione: json['manutenzione'],
      rifornimento: json['rifornimento']
  );


}