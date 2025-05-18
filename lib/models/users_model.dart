class UserModel {
  int? id;
  late String nom;
  late String tel;
  late String? email;
  late String password;
  late String adresse;
  late String role;
  late String arrondissement;

  UserModel(
      {this.id,
        required this.nom,
        required this.tel,
        required this.email,
        required this.password,
        required this.adresse,
        required this.role,
        required this.arrondissement
      });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nom = json['nom'];
    tel = json['tel'];
    email = json['email'];
    password = json['password'];
    adresse = json['adresse'];
    role = json['role'];
    arrondissement = json['arrondissement'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nom'] = nom;
    data['tel'] = tel;
    data['email'] = email;
    data['password'] = password;
    data['adresse'] = adresse;
    data['role'] = role;
    data['arrondissement'] =  arrondissement ;
    return data;
  }
}
