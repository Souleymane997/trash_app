
// ignore_for_file: non_constant_identifier_names

class RequeteModel {
  late int requete_id;
  late String structure_id ;
  late String user_id;
  late String statut;
  late String date_requete; 

  RequeteModel(
      { required this.requete_id,
        required this.structure_id,
        required this.user_id,
        required this.statut,
        required this.date_requete
      });

  factory RequeteModel.fromJson(Map<String, dynamic> json) {
    return RequeteModel(
      requete_id: json['requete_id'],
      structure_id: json['structure_id'],
      user_id: json['user_id'],
      statut: json['statut'],
      date_requete: json['date_requete'],
    );
  
  }
}