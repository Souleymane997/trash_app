// ignore_for_file: non_constant_identifier_names


class AbonnModel {
  late int abonnement_id;
  late String user_id ;
  late int service_id;
  late bool actif;

  AbonnModel(
      { required this.abonnement_id,
        required this.user_id,
        required this.service_id,
        required this.actif
      });

  AbonnModel.fromJson(Map<String, dynamic> json) {
    abonnement_id = json['abonnement_id'];
    user_id = json['user_id'];
    service_id = json['service_id'];
    actif = json['actif'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['abonnement_id'] =abonnement_id;
    data['user_id'] =user_id;
    data['service_id'] =service_id ;
    data['actif'] = actif;

    return data;
  }

}



class AbonnUserModel {
  late int abonnement_id;
  late String structure_id;
  late String nom ;
  late String tel ;
  late String nom_service;
  late bool actif;

  AbonnUserModel(
      { required this.abonnement_id,
        required this.structure_id,
        required this.nom,
        required this.nom_service,
        required this.tel,
        required this.actif
      });

  factory AbonnUserModel.fromJson(Map<String, dynamic> json) {
    return AbonnUserModel(
      abonnement_id: json['abonnement_id'],
      nom: json['users']['nom'],
      tel: json['users']['tel'],
      nom_service: json['services']['nom_service'],
      structure_id: json['services']['structure_id'],
      actif: json['actif'],
    );
  }
}

