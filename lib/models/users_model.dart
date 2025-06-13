// ignore_for_file: non_constant_identifier_names


class UserModel {
  late String id;
  late String nom;
  late String tel;
  late String? email;
  late String password;
  late String adresse;
  late int role_id;
  late String role ;
  late int secteur_id;
  late String secteur;
  late int arrondissement_id;
  late String arrondissement;

  UserModel(
      {required this.id,
        required this.nom,
        required this.tel,
        required this.email,
        required this.password,
        required this.adresse,
        required this.role,
        required this.role_id,
        required this.secteur_id,
        required this.secteur,
        required this.arrondissement,
        required this.arrondissement_id
      });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id : json['id'],
        nom : json['nom'],
        tel : json['tel'],
        email : json['email'],
        password : json['password'],
        adresse : json['adresse'],
        role : json['role']['role'],
        role_id : json['role']['id'],
        secteur : json['secteurs']['secteur'],
        secteur_id : json['secteurs']['id'],
        arrondissement_id: json['arrondissements']['id'],
        arrondissement: json['arrondissements']['arrondissement'],
    );
  }

}
