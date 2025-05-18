// ignore_for_file: non_constant_identifier_names

class SecteurModel {
  int? id;
  late String secteur;
  late int arrondissement_id;
  late String arrondissement;

  SecteurModel(
      {this.id,
        required this.secteur,
        required this.arrondissement_id,
        required this.arrondissement,
      });

  factory SecteurModel.fromJson(Map<String, dynamic> json) {
    return SecteurModel(
      id: json['id'],
      secteur: json['secteur'],
      arrondissement_id: json['arrondissements']['id'],
      arrondissement: json['arrondissements']['arrondissement'],
    );
  }



}
