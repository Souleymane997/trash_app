// ignore_for_file: non_constant_identifier_names


class StructureModel {
  late String id;
  late String nomStructure;
  late String tel;
  late String email;
  late int arrondissement_id;
  late String arrondissement;
  late String password;
  late int role_id;

  StructureModel (
      {required this.id,
        required this.nomStructure,
        required this.tel,
        required this.arrondissement_id,
        required this.arrondissement,
        required this.email,
        required this.password,
        required this.role_id
      });


  factory StructureModel.fromJson(Map<String, dynamic> json) {
    return StructureModel(
      id: json['id'],
      nomStructure: json['nom_structure'],
      arrondissement_id: json['arrondissements']['id'],
      arrondissement: json['arrondissements']['arrondissement'],
      email: json['email'],
      password: json['password'],
      tel: json['tel'],
      role_id: json['role']['id'],
    );
  }
}
