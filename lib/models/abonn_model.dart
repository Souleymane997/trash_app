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
