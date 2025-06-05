// ignore_for_file: non_constant_identifier_names


class ServiceModel {
  late int service_id;
  late String structure_id;
  late String nom_service;
  late int nbre;
  late double tarif ;
  late String description;


  ServiceModel(
      {required this.service_id,
        required this.structure_id,
        required this.nom_service,
        required this.nbre,
        required this.tarif,
        required this.description
      });

  ServiceModel.fromJson(Map<String, dynamic> json) {
    service_id = json['service_id'];
    structure_id = json['structure_id'];
    nom_service = json['nom_service'];
    nbre = json['nbre'];
    tarif = json['tarif'];
    description= json['description'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['service_id'] = service_id ;
    data['structure_id'] =  structure_id;
    data['nom_service'] = nom_service ;
    data['nbre'] = nbre ;
    data['tarif'] =  tarif ;
    data['description'] = description;

    return data;
  }

  @override
  String toString() {
    return nom_service;
  }
}
